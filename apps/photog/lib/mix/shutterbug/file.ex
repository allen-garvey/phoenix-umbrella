defmodule Photog.Shutterbug.File do
  alias Common.MixHelpers.Error
  alias Photog.Shutterbug.Directory

  @doc """
  Returns map of file directories with unique keys to use
  as file prefixes, so we don't get clashes when importing
  files with the same name in different directories
  """
  def get_directory_prefix_map(files) do
    dir_keys =
      files
      |> Enum.map(fn file -> Path.dirname(file) end)
      |> Enum.uniq()
      |> Enum.sort(:asc)

    pad_amount =
      dir_keys
      |> Enum.count()
      |> :math.log10()
      |> trunc()
      |> Kernel.+(1)

    dir_keys
    |> Enum.with_index(fn key, index ->
      {key, String.pad_leading("#{index + 1}", pad_amount, "0")}
    end)
    |> Map.new()
  end

  def add_prefix_to_file(directory_prefix_map, source_path) do
    prefix = Map.get(directory_prefix_map, Path.dirname(source_path))
    "#{prefix}_#{Path.basename(source_path)}"
  end

  def file_path_with_prefix(directory_prefix_map, source_path, dest_path) do
    Path.join(dest_path, add_prefix_to_file(directory_prefix_map, source_path))
  end

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
    !File.dir?(filename) and
      Regex.match?(~r/^\.(avif|heic|jpg|jpeg|png|svg|webp)$/i, Path.extname(filename))
  end

  @doc """
  Copies source to destination but exits with error if destination file already exists
  """
  def safe_copy(source_path, destination_path) do
    File.cp!(source_path, destination_path, fn _, dest ->
      Error.exit_with_error("#{dest} already exists", :dest_file_already_exists)
    end)

    # make sure permissions are good, since some devices (such as phones) can have too restrictive permissions which won't allow web server to serve image file
    File.chmod!(destination_path, 0o644)

    Path.basename(destination_path)
  end

  @doc """
  Create directories for masters and thumbnails
  """
  def create_directories_for_masters_and_thumbnails(
        masters_target_directory_name,
        thumbnails_target_directory_name,
        now
      ) do
    target_relative_path = Directory.import_relative_path(now)
    masters_path = Directory.masters_path(masters_target_directory_name, now)
    thumbnails_path = Directory.thumbnails_path(thumbnails_target_directory_name, now)

    if File.exists?(masters_path) do
      Error.exit_with_error("#{masters_path} already exists", :masters_directory_exists)
    end

    if File.exists?(thumbnails_path) do
      Error.exit_with_error("#{thumbnails_path} already exists", :thumbnails_directory_exists)
    end

    File.mkdir_p!(masters_path)
    File.mkdir_p!(thumbnails_path)

    {target_relative_path, masters_path, thumbnails_path}
  end
end
