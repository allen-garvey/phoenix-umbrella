defmodule Photog.Shutterbug.File do
  alias Common.MixHelpers.Error

  @doc """
  Returns list of image files for a given directory
  """
  def get_image_files(directory_name) do
  	get_files_recursive(directory_name)
  	|> Enum.filter(&is_image_filename/1)
  end

  def get_files_recursive(directory_name) do
    File.ls!(directory_name)
    |> Enum.map(fn file_name -> 
      file_name_full = Path.join(directory_name, file_name)
      {File.dir?(file_name_full), file_name_full}
    end)
    |> Enum.sort(:asc)
    |> Enum.flat_map(fn {is_dir, file_name_full} ->
      if is_dir do
        get_files_recursive(file_name_full)
      else
        [file_name_full]
      end
    end)
  end

  @doc """
  Checks file extension to see if file is image
  Possibly in the future use `mimetype` command instead, but that will be less portable
  Not checking for .tiff since not all browsers can show them
  Could potentially add .gif in future, but no need for it now
  """
  def is_image_filename(filename) do
  	!File.dir?(filename) and Regex.match?(~r/^\.(heic|jpg|jpeg|png|svg|webp)$/i, Path.extname(filename))
  end

  @doc """
  Copies source to destination but exits with error if destination file already exists
  """
  def safe_copy(source_path, destination_path) do
    File.cp!(source_path, destination_path, fn _,  dest -> Error.exit_with_error("#{dest} already exists", :dest_file_already_exists) end)
    # make sure permissions are good, since some devices (such as phones) can have too restrictive permissions which won't allow web server to serve image file
    File.chmod!(destination_path, 0o644)

    Path.basename(destination_path)
  end

  @doc """
  Takes image at source path and converts to webp lossless at destination path
  """
  def convert_to_webp_lossless(image_source_path, image_destination_path) do
    webp_destination_path = Photog.Shutterbug.Image.webp_name(image_destination_path)

    with {_, 0} <- System.cmd("convert", [image_source_path, "-define", "webp:lossless=true", "-auto-orient", webp_destination_path]) do
      # file permissions should be correct (tested with convert command and permissions are +r) but set permissions just in case
      File.chmod!(webp_destination_path, 0o644)
    else
      _ -> Error.exit_with_error("Error converting #{image_source_path} to #{webp_destination_path} using convert", :error_converting_to_webp_lossless)
    end

    Path.basename(webp_destination_path)
  end

  @doc """
  Takes image at source path and converts to webp lossy at destination path
  """
  def convert_to_webp_lossy(image_source_path, image_destination_path) do
    webp_destination_path = Photog.Shutterbug.Image.webp_name(image_destination_path)

    with {_, 0} <- System.cmd("convert", [image_source_path, "-quality", "85%", "-auto-orient", webp_destination_path]) do
      # file permissions should be correct (tested with convert command and permissions are +r) but set permissions just in case
      File.chmod!(webp_destination_path, 0o644)
    else
      _ -> Error.exit_with_error("Error converting #{image_source_path} to #{webp_destination_path} using convert", :error_converting_to_webp_lossless)
    end

    Path.basename(webp_destination_path)
  end

  @doc """
  Resizes image to given dimension on shortest side using imagemagick
  Resize on largest side from: https://www.imagemagick.org/discourse-server/viewtopic.php?t=13175
  """
  def resize_image(image_source_path, image_destination_path, size) when is_integer(size) do
    with {_, 0} <- System.cmd("convert", [image_source_path, "-resize", "#{size}^>", "-quality", "75%", "-auto-orient", image_destination_path]) do
      # file permissions should be correct (tested with convert command and permissions are +r) but set permissions just in case
      File.chmod!(image_destination_path, 0o644)
    else
      _ -> Error.exit_with_error("Error converting #{image_source_path} to #{image_destination_path} using convert", :error_creating_thumbnail)
    end
  end

end
