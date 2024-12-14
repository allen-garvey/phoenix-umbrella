defmodule Mix.Tasks.Shutterbug do
  use Mix.Task

  alias Grenadier.Repo
  alias Common.MixHelpers.Error
  alias Photog.Shutterbug.FileValidator
  alias Common.MixHelpers.Command
  alias Photog.Image.Exif
  alias Photog.Shutterbug.File

  @moduledoc """
  Given a directory of images, will copy image files to masters directory, create thumbnails, and add image resources to database
  """
  @doc """
  Imports images from source directory to ./priv/static/media. Will create image resources in the database and group the images in an import resources.
  """
  def run([source_directory_name]) do
    import_images_from_directory(source_directory_name, false)
  end

  def run([source_directory_name, "--webp"]) do
    IO.puts("Importing images with convert masters to webp option")
    import_images_from_directory(source_directory_name, true)
  end

  def run(_args) do
    Error.exit_with_error("usage: mix shutterbug <image_source_directory>")
  end

  defp validate_args(directories) do
    directories
    |> Enum.all?(&FileValidator.validate_import_directory!/1) and
      Command.validate_commands_are_installed!(["convert", "exiftool"])
  end

  @doc """
  Imports image files from directory
  """
  def import_images_from_directory(source_directory_name, convert_to_webp)
      when is_boolean(convert_to_webp) do
    masters_destination_path = Photog.Image.masters_directory()
    thumbnails_destination_path = Photog.Image.thumbnails_directory()

    if validate_args([
         source_directory_name,
         masters_destination_path,
         thumbnails_destination_path
       ]) do
      import_images_from_directory(
        source_directory_name,
        masters_destination_path,
        thumbnails_destination_path,
        convert_to_webp
      )
    end
  end

  def import_images_from_directory(
        source_directory_name,
        masters_target_directory_name,
        thumbnails_target_directory_name,
        convert_to_webp
      )
      when is_boolean(convert_to_webp) do
    image_files = get_image_files(source_directory_name)
    directory_prefix_map = File.get_directory_prefix_map(image_files)

    # create directories for masters and thumbnails
    now = DateTime.utc_now()

    {target_relative_path, masters_path, thumbnails_path} =
      File.create_directories_for_masters_and_thumbnails(
        masters_target_directory_name,
        thumbnails_target_directory_name,
        now
      )

    # disable logging of database queries
    Logger.configure(level: :error)
    # start app so repo is available
    Mix.Task.run("app.start", [])

    Repo.transaction(
      fn ->
        # create import
        import_id = Photog.Shutterbug.Import.create_import()
        # get count for progress countdown
        image_file_count = Enum.count(image_files)

        for {image_source_path, index} <- Enum.with_index(image_files) do
          IO.puts("Importing image #{index + 1}/#{image_file_count} #{image_source_path}")

          # create image master
          image_master_path =
            File.file_path_with_prefix(directory_prefix_map, image_source_path, masters_path)

          master_name = create_image_master(image_source_path, image_master_path, convert_to_webp)

          # create thumbnails
          {thumbnail_name, mini_thumbnail_name} =
            create_image_thumbnails(directory_prefix_map, image_source_path, thumbnails_path)

          # get paths needed when creating image resource
          image_thumbnail_relative_path = Path.join(target_relative_path, thumbnail_name)

          image_mini_thumbnail_relative_path =
            Path.join(target_relative_path, mini_thumbnail_name)

          image_master_relative_path = Path.join(target_relative_path, master_name)

          # get exif data for creation_time
          {exif_map, creation_datetime} = get_image_exif(image_source_path, now)

          image =
            Photog.Shutterbug.Image.create_image!(%{
              master_path: image_master_relative_path,
              mini_thumbnail_path: image_mini_thumbnail_relative_path,
              thumbnail_path: image_thumbnail_relative_path,
              import_id: import_id,
              creation_time: creation_datetime,
              exif: exif_map
            })

          if index == 0 do
            Photog.Shutterbug.Import.update_cover_image(import_id, image.id)
          end
        end
      end,
      timeout: :infinity
    )
  end

  def get_image_files(source_directory_name) do
    image_files = File.get_image_files(source_directory_name)

    if Enum.empty?(image_files) do
      Error.exit_with_error(
        "No image files found in #{source_directory_name}",
        :no_images_in_source_directory
      )
    end

    image_files
  end

  @doc """
  Either converts png image to webp lossless, or for other image types copies to masters folder
  """
  def create_image_master(image_source_path, image_master_path, convert_to_webp)
      when is_boolean(convert_to_webp) do
    case File.get_image_master_action_for(image_source_path, convert_to_webp) do
      :safe_copy ->
        File.safe_copy(image_source_path, image_master_path)

      :convert_to_webp_lossy ->
        File.convert_to_webp_lossy(image_source_path, image_master_path)

      :convert_to_webp_lossless ->
        File.convert_to_webp_lossless(image_source_path, image_master_path)
    end
  end

  @doc """
  Creates image thumbnails given image thumbnail file name, image source directory and path to create thumbnails in
  """
  def create_image_thumbnails(directory_prefix_map, image_source_path, thumbnails_path) do
    thumbnail_name =
      create_thumbnail(
        Path.extname(image_source_path) == ".svg",
        directory_prefix_map,
        image_source_path,
        thumbnails_path
      )

    mini_thumbnail_name =
      create_mini_thumbnail(directory_prefix_map, image_source_path, thumbnails_path)

    {thumbnail_name, mini_thumbnail_name}
  end

  @doc """
  First argument is should_copy - if true just copies, otherwise resizes
  """
  def create_thumbnail(true, directory_prefix_map, image_source_path, thumbnails_path) do
    image_thumbnail_path =
      File.file_path_with_prefix(directory_prefix_map, image_source_path, thumbnails_path)

    File.safe_copy(image_source_path, image_thumbnail_path)

    Path.basename(image_thumbnail_path)
  end

  def create_thumbnail(false, directory_prefix_map, image_source_path, thumbnails_path) do
    thumbnail_name =
      File.add_prefix_to_file(directory_prefix_map, image_source_path)
      |> Photog.Shutterbug.Image.thumbnail_name()

    image_thumbnail_path = Path.join(thumbnails_path, thumbnail_name)
    File.resize_image(image_source_path, image_thumbnail_path, 768)

    thumbnail_name
  end

  def create_mini_thumbnail(directory_prefix_map, image_source_path, thumbnails_path) do
    mini_thumbnail_name =
      File.add_prefix_to_file(directory_prefix_map, image_source_path)
      |> Photog.Shutterbug.Image.mini_thumbnail_name()

    image_mini_thumbnail_path = Path.join(thumbnails_path, mini_thumbnail_name)
    File.resize_image(image_source_path, image_mini_thumbnail_path, 300)

    mini_thumbnail_name
  end

  def get_image_exif(image_source_path, now) do
    exif_map = Common.ImageHelpers.Exif.exif_for(image_source_path)

    creation_datetime =
      case Exif.exif_creation_time_as_datetime(exif_map) do
        {:ok, datetime, _} ->
          datetime

        {:error, reason} ->
          Error.exit_with_error(
            "#{image_source_path} exif creation date is in the wrong format because #{reason}",
            :image_exif_creation_date_wrong_format
          )

        nil ->
          now
      end

    {exif_map, creation_datetime}
  end
end
