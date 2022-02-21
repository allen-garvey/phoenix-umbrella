defmodule Artour.Guggenheim.Image do
    @doc """
    Parses year from source directory if possible
    """
    def get_image_year(source_directory_name, current_year) do
        year = Regex.split(~r/[ _-]+/, source_directory_name)
        |> Enum.reduce(nil, fn part, year -> 
            if is_nil(year) and Regex.match?(~r/^[1-9]\d{3}$/, part) do
                String.to_integer(part)
            else
                year
            end
        end)

        year || current_year
    end

    @doc """
    Gets list of images in directory
    """
    def get_images_from_dir(source_directory_name) do
        File.ls!(source_directory_name)
        |> Enum.filter(&is_image_filename/1)
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
  
end
  