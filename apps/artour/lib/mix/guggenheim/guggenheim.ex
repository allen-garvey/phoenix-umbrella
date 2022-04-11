#run task with 'mix distill.site'
defmodule Mix.Tasks.Guggenheim do
    use Mix.Task

    alias Common.MixHelpers.Error
    alias Artour.Guggenheim.Filesystem
    alias Artour.Guggenheim.Image
  
    @shortdoc "Import images into artour"
    def run([source_directory_name, image_description, use_liquid_resize]) do
      import_images(source_directory_name, image_description, use_liquid_resize == "true")
    end

    def run([source_directory_name, image_description]) do
      import_images(source_directory_name, image_description)
    end

    def run([source_directory_name]) do
      import_images(source_directory_name)
    end
    
    def run(_args) do
      Error.exit_with_error("usage: mix guggenheim <image_source_directory> <?image_description> <?use_liquid_resize:true|false>")
    end

    def import_images(source_directory_name, image_description \\ nil, use_liquid_resize \\ true) do
      # Check if necessary shell commands are installed
      Common.MixHelpers.Command.validate_commands_are_installed!(["convert", "exiftool", "jpegoptim"])

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
      temp_dir = Filesystem.create_temp_dir!(source_directory_name)

      # Create thumbnails in temp dir
      case use_liquid_resize do
        true -> Image.create_liquid_thumbnails(temp_dir, source_image_models)
        false -> Image.create_thumbnails(temp_dir, source_image_models)
      end

      # Start Artour app so db is available
      Mix.Task.run "app.start", []

      Artour.Repo.transaction(fn ->
        # Create image resource for each image path
        for {image_path, image_orientation} <- source_image_models do
          IO.puts "Converting and importing #{image_path}"
          
          image_title = Image.path_to_title(image_path)
          
          image_map = %{
            "title" => image_title,
            "description" => image_description || image_title,
            "year" => image_year,
          }
          |> Map.merge(Image.generate_images(image_path, temp_dir, image_orientation))
          
          {:ok, _image} = Artour.Admin.create_image(image_map)
        end
      end, timeout: :infinity)

      # Fix permissions and optimize jpgs
      Filesystem.fix_permissions(temp_dir)
      Image.optimize_jpgs(temp_dir)
      
      image_priv_dir = Path.join([__ENV__.file, "..", "..", "..", "..", "priv", "static", "media", "images"])
      |> Path.expand
      IO.puts "\n\nImages imported. Copy contents of #{temp_dir} to #{image_priv_dir}"
    end
  end