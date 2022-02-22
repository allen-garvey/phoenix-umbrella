#run task with 'mix distill.site'
defmodule Mix.Tasks.Guggenheim do
    use Mix.Task

    alias Artour.Guggenheim.Error
    alias Artour.Guggenheim.Filesystem
    alias Artour.Guggenheim.Image
  
    @shortdoc "Import images into artour"
    def run([source_directory_name]) do
      # Check if imagemagick and exiftool are installed
      Artour.Guggenheim.Command.are_import_commands_available()

      # Validate source directory
      if !File.dir?(source_directory_name) do
        Error.exit_with_error("#{source_directory_name} is not a valid directory", :dir_not_exists)
      end

      # Get year for images from source directory, or default to current year
      current_year = Common.ModelHelpers.Date.today().year
      image_year = Image.get_image_year(source_directory_name, current_year)
      
      # Get list of image filenames
      source_image_models = Image.get_images_from_dir(source_directory_name)
      if Enum.count(source_image_models) == 0 do
        Error.exit_with_error("#{source_directory_name} contains no detected images", :no_images_found)
      end

      # Create temp dir for converted images, exit if already exists
      temp_dir = Filesystem.create_temp_dir(source_directory_name)

      # Create liquid thumbnails in temp dir
      Image.create_liquid_thumbnails(temp_dir, source_image_models)

      # Start Artour app so db is available
      # Wrap for loop in transaction
      # Create image resource for each image path
      for {image_path, image_orientation} <- source_image_models do
        image_title = Image.path_to_title(image_path)
        
        image_map = %{
          "title" => image_title,
          "description" => image_title,
          "year" => image_year,
        }
        |> Map.merge(Image.generate_images(image_path, temp_dir, image_orientation))
        
        IO.inspect image_map
      end

      # Fix permissions on temp folder
      Filesystem.fix_permissions(temp_dir)
      # Run optipng on temp folder
      Image.optimize_pngs(temp_dir)
      # Run jpg optimization on temp folder
      Image.optimize_jpgs(temp_dir)
      # Print message to copy temp dir to source image folders
      IO.puts "Images imported. Copy contents of #{temp_dir} to image source directory"
    end
    
    def run(_args) do
      Error.exit_with_error("usage: mix guggenheim <image_source_directory>")
    end
  end