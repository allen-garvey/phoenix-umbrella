#run task with 'mix distill.site'
defmodule Mix.Tasks.Guggenheim do
    use Mix.Task

    alias Artour.Guggenheim.Error
    alias Artour.Guggenheim.Image
  
    @shortdoc "Import images into artour"
    def run([source_directory_name]) do
      # Validate source directory
      if !File.dir?(source_directory_name) do
        Error.exit_with_error("#{source_directory_name} is not a valid directory", :dir_not_exists)
      end

      # Get year for images from source directory, or default to current year
      current_year = Common.ModelHelpers.Date.today().year
      image_year = Image.get_image_year(source_directory_name, current_year)
      
      # Get list of image filenames
      image_paths = Image.get_images_from_dir(source_directory_name)
      if Enum.count(image_paths) == 0 do
        Error.exit_with_error("#{source_directory_name} contains no detected images", :no_images_found)
      end

      for image_path <- image_paths do
        IO.puts "Image_name #{Image.path_to_title(image_path)} Image_year #{image_year}"
      end
    end
    
    def run(_args) do
      Error.exit_with_error("usage: mix guggenheim <image_source_directory>")
    end
  end