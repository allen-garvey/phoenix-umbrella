defmodule Mix.Tasks.Shutterbug do
  use Mix.Task

  alias Photog.Shutterbug.Error
  alias Photog.Shutterbug.Directory
  alias Photog.Shutterbug.FileValidator
  alias Photog.Shutterbug.Command
  alias Photog.Image.Exif

  @moduledoc """
  Given a directory of images, will copy image files to masters directory, create thumbnails, and add image resources to database
  """
  @doc """
  Imports images from source directory to (optional) destination directory. If no directory given, will default to ./priv/static/media, or separate masters and thumbnail destination directories can be given
  """
  def run([source_directory_name]) do
    masters_destination_path = Photog.Image.masters_directory()
    thumbnails_destination_path = Photog.Image.thumbnails_directory()
    if FileValidator.validate_import_directory!(source_directory_name) and FileValidator.validate_import_directory!(masters_destination_path) and FileValidator.validate_import_directory!(thumbnails_destination_path) and Command.are_import_commands_available do
      import_images_from_directory(source_directory_name, masters_destination_path, thumbnails_destination_path)
    end
  end

  def run([source_directory_name, target_directory_name]) do
    if FileValidator.validate_import_directory!(source_directory_name) and FileValidator.validate_import_directory!(target_directory_name) and Command.are_import_commands_available do
      import_images_from_directory(source_directory_name, Path.join(target_directory_name, "Masters"), Path.join(target_directory_name, "Thumbnails"))
    end
  end

  def run([source_directory_name, target_masters_directory_name, target_thumbnails_directory_name]) do
    if FileValidator.validate_import_directory!(source_directory_name) and FileValidator.validate_import_directory!(target_masters_directory_name) and FileValidator.validate_import_directory!(target_thumbnails_directory_name) and Command.are_import_commands_available do
      import_images_from_directory(source_directory_name, target_masters_directory_name, target_thumbnails_directory_name)
    end
  end

  def run(_args) do
  	Error.exit_with_error("usage: mix shutterbug <image_source_directory> <image_library_destination_directory>")
  end

  @doc """
  Imports image files from directory
  """
  def import_images_from_directory(source_directory_name, masters_target_directory_name, thumbnails_target_directory_name) do
  	image_files = Photog.Shutterbug.File.get_image_files(source_directory_name)

  	if Enum.empty?(image_files) do
  		Error.exit_with_error("No image files found in #{source_directory_name}", :no_images_in_source_directory)
    end

    #create directories for masters and thumbnails
    now = DateTime.utc_now()
    target_relative_path = Directory.import_relative_path(now)
    masters_path = Directory.masters_path(masters_target_directory_name, now)
    thumbnails_path = Directory.thumbnails_path(thumbnails_target_directory_name, now)

    if File.exists?(masters_path) do
      Error.exit_with_error("#{masters_path} already exists", :masters_directory_exists)
    end
    File.mkdir_p!(masters_path)

    if File.exists?(thumbnails_path) do
      Error.exit_with_error("#{thumbnails_path} already exists", :thumbnails_directory_exists)
    end
    File.mkdir_p!(thumbnails_path)

    #start app so repo is available
    Mix.Task.run "app.start", []

    #create import
    import_id = Photog.Shutterbug.Import.create_import()

    for image_source_path <- image_files do
      IO.puts "Importing #{image_source_path}"

      #get image filename
      image_file = Path.basename(image_source_path)
      # copy image master
      image_master_path = Path.join(masters_path, image_file)
      Photog.Shutterbug.File.safe_copy(image_source_path, image_master_path)

      #create thumbnails
      thumbnail_name = Photog.Shutterbug.Image.thumbnail_name(image_file)
      mini_thumbnail_name = Photog.Shutterbug.Image.mini_thumbnail_name(image_file)

      image_thumbnail_path = Path.join(thumbnails_path, thumbnail_name)
      image_mini_thumbnail_path = Path.join(thumbnails_path, mini_thumbnail_name)

      Photog.Shutterbug.File.resize_image(image_source_path, image_thumbnail_path, 768)
      Photog.Shutterbug.File.resize_image(image_source_path, image_mini_thumbnail_path, 250)

      #get paths needed when creating image resource
      image_thumbnail_relative_path = Path.join(target_relative_path, thumbnail_name)
      image_mini_thumbnail_relative_path = Path.join(target_relative_path, mini_thumbnail_name)
      image_master_relative_path = Path.join(target_relative_path, image_file)

      #get exif data for creation_time
      exif_map = Exif.exif_for(image_master_path)
      creation_datetime = case Exif.exif_creation_time_as_datetime(exif_map) do
        {:ok, datetime, _} -> datetime
        {:error, reason}   -> Error.exit_with_error("#{image_source_path} exif creation date is in the wrong format because #{reason}", :image_exif_creation_date_wrong_format)
        nil                -> now
      end

      Photog.Shutterbug.Image.create_image!(%{
        master_path: image_master_relative_path,
        mini_thumbnail_path: image_mini_thumbnail_relative_path,
        thumbnail_path: image_thumbnail_relative_path,
        import_id: import_id,
        creation_time: creation_datetime,
      })

  	end
  end
end
