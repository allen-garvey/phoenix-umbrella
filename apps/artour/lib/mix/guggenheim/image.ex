defmodule Artour.Guggenheim.Image do
  @doc """
  Parses year from source directory if possible
  """
  def get_image_year(source_directory_name, current_year) do
    Regex.split(~r/[ _-]+/, source_directory_name)
    |> Enum.find_value(current_year, fn part ->
      case Regex.match?(~r/^[1-2]\d{3}$/, part) do
        true -> String.to_integer(part)
        _ -> false
      end
    end)
  end

  @doc """
  Gets list of images in directory
  """
  def get_images_from_dir(source_directory_name) do
    File.ls!(source_directory_name)
    |> Enum.map(fn path -> Path.join(source_directory_name, path) end)
    |> Enum.filter(&is_image_filename/1)
    |> Enum.map(fn image_path_full -> {image_path_full, get_orientation(image_path_full)} end)
  end

  @doc """
  Checks file extension to see if file is image
  Possibly in the future use `mimetype` command instead, but that will be less portable
  Could potentially add gif, svg and tiff in future, but no need for it now
  """
  def is_image_filename(filename) do
    !File.dir?(filename) and Regex.match?(~r/^\.(jpg|jpeg|png|webp)$/i, Path.extname(filename))
  end

  @doc """
  Converts filename for image to name by capitalizing each word and turning separators into spaces

  ## Examples

    iex> filename_to_name("an_image_filename.png")
    "An Image Filename"

    iex> filename_to_name("an-image-filename.jpg")
    "An Image Filename"
  """
  def path_to_title(image_path) do
    Path.basename(image_path, Path.extname(image_path))
    |> (fn name -> Regex.split(~r/[ _-]+/, name) end).()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def get_orientation(image_path) do
    exif = Common.ImageHelpers.Exif.exif_for(image_path)

    # square images are considered landscape
    case exif["ImageWidth"] < exif["ImageHeight"] do
      false -> :landscape
      true -> :portrait
    end
  end

  @doc """
  Create square thumbnails
  """
  def create_thumbnails(temp_dir, source_image_models) do
    thumbnail_size = 200

    source_image_models
    |> Enum.map(fn {image_path, _orientation} ->
      {_res, 0} =
        System.cmd("convert", [
          image_path,
          "-thumbnail",
          "#{thumbnail_size}x#{thumbnail_size}^",
          "-gravity",
          "center",
          "-extent",
          "#{thumbnail_size}x#{thumbnail_size}",
          "-quality",
          "40%",
          "-set",
          "filename:name",
          "%t",
          Path.join(temp_dir, "%[filename:name]-thumb.webp")
        ])
    end)
  end

  def generate_images(image_path, temp_dir, orientation) do
    images = %{
      "filename_thumbnail" => "#{Path.basename(image_path, Path.extname(image_path))}-thumb.webp",
      "filename_small" => generate_image_size(image_path, temp_dir, 500, "sm"),
      "filename_medium" => generate_image_size(image_path, temp_dir, 900, "med")
    }

    large_image_path =
      case orientation do
        :landscape -> generate_image_size(image_path, temp_dir, 1600, "lg")
        :portrait -> images["filename_medium"]
      end

    images
    |> Map.put("filename_large", large_image_path)
  end

  @doc """
  Create a resized version of an image in the temp dir with suffix
  Image created is webp, but even if source was png quality still looks sufficient and image size is much smaller
  """
  def generate_image_size(image_path, temp_dir, size, suffix) do
    System.cmd("convert", [
      image_path,
      "-resize",
      "#{size}",
      "-quality",
      "80%",
      "-set",
      "filename:name",
      "%t",
      Path.join(temp_dir, "%[filename:name]-#{suffix}.webp")
    ])

    "#{Path.basename(image_path, Path.extname(image_path))}-#{suffix}.webp"
  end
end
