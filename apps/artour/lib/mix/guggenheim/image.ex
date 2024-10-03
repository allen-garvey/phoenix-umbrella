defmodule Artour.Guggenheim.Image do
    @thumbnail_size "200"

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
        |> Enum.filter(&is_image_filename/1)
        |> Enum.map(fn image_path -> Path.join(source_directory_name, image_path) end)
        |> Enum.map(fn image_path -> {image_path, get_orientation(image_path)} end)
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
        source_image_models
        # Resize images first to make liqid resize faster
        |> Enum.map(fn {image_path, _orientation} -> 
            {_res, 0} = System.cmd("convert", [image_path, "-thumbnail", "#{@thumbnail_size}x#{@thumbnail_size}^", "-gravity", "center", "-extent", "#{@thumbnail_size}x#{@thumbnail_size}", "-quality", "40%", "-set", "filename:name", "%t", Path.join(temp_dir, "%[filename:name]-thumb.jpg")])
        end)
    end
    
    @doc """
    Create square thumbnails using liquid resize
    """
    def create_liquid_thumbnails(temp_dir, source_image_models) do
        source_image_models
        # Resize images first to make liqid resize faster
        |> Enum.map(fn {image_path, _orientation} -> 
            {_res, 0} = System.cmd("convert", [image_path, "-resize", @thumbnail_size, "-set", "filename:name", "%t", Path.join(temp_dir, "%[filename:name]-thumb.png")])

            Path.join(temp_dir, Path.basename(image_path, Path.extname(image_path)) <> "-thumb.png")
        end)
        |> Enum.map(fn image_path -> 
            {_res, 0} = System.cmd("convert", [image_path, "-liquid-rescale", "#{@thumbnail_size}x#{@thumbnail_size}!", "-quality", "40%", "-blur", "1x1", "-set", "filename:name", "%t", Path.join(temp_dir, "%[filename:name]-a.jpg")])

            # remove png since now no longer needed
            File.rm!(image_path)
        end)
    end

    @doc """
    Optimize jpg file size
    """
    def optimize_jpgs(temp_dir) do
        jpgs = Path.join(temp_dir, "*.jpg") |> Path.wildcard

        if Enum.count(jpgs) > 0 do
            System.cmd("jpegoptim", jpgs)
        end
    end

    def generate_images(image_path, temp_dir, orientation) do
        images = %{
            "filename_thumbnail" => "#{Path.basename(image_path, Path.extname(image_path))}-thumb.jpg",
            "filename_small" => generate_image_size(image_path, temp_dir, 500, "sm"),
            "filename_medium" => generate_image_size(image_path, temp_dir, 900, "med"),
        }
        large_image = case orientation do
            :landscape -> %{"filename_large" => generate_image_size(image_path, temp_dir, 1600, "lg")}
            :portrait -> %{"filename_large" => images["filename_medium"]}
        end

        Map.merge(images, large_image)
    end

    @doc """
    Create a resized version of an image in the temp dir with suffix
    Image created is jpeg, but even if source was png quality still looks sufficient
    and image size is much smaller
    Eventually replace with lossy webp once iOS / iPad OS < 14 market share is low enough
    """
    def generate_image_size(image_path, temp_dir, size, suffix) do
        System.cmd("convert", [image_path, "-resize", "#{size}", "-quality", "80%", "-set", "filename:name", "%t", Path.join(temp_dir, "%[filename:name]-#{suffix}.jpg")])

        "#{Path.basename(image_path, Path.extname(image_path))}-#{suffix}.jpg"
    end
end
  