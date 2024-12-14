defmodule Mix.Tasks.Shutterbug do
  use Mix.Task

  alias Photog.Shutterbug.ImageThumbnailPlan
  alias Grenadier.Repo
  alias Common.MixHelpers.Error
  alias Photog.Shutterbug.FileValidator
  alias Common.MixHelpers.Command
  alias Photog.Image.Exif
  alias Photog.Shutterbug.File
  alias Photog.Shutterbug.Planner
  alias Photog.Shutterbug.ImageMasterPlan
  alias Photog.Shutterbug.Convert

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
    image_file_count = Enum.count(image_files)

    # create directories for masters and thumbnails
    now = DateTime.utc_now()

    {target_relative_path, masters_path, thumbnails_path} =
      File.create_directories_for_masters_and_thumbnails(
        masters_target_directory_name,
        thumbnails_target_directory_name,
        now
      )

    image_plans =
      Planner.make_plan_for_images(image_files, masters_path, thumbnails_path, convert_to_webp)

    for {image_plan, index} <- Enum.with_index(image_plans) do
      IO.puts(
        "Converting image #{index + 1}/#{image_file_count} #{image_plan.master_plan.source_path}"
      )

      create_image_master(image_plan.master_plan)
      create_thumbnail(image_plan.thumbnail_plan)
      create_thumbnail(image_plan.mini_thumbnail_plan)
    end

    # disable logging of database queries
    Logger.configure(level: :error)
    # start app so repo is available
    Mix.Task.run("app.start", [])

    Repo.transaction(
      fn ->
        import_id = Photog.Shutterbug.Import.create_import()

        for {image_plan, index} <- Enum.with_index(image_plans) do
          IO.puts(
            "Importing image #{index + 1}/#{image_file_count} #{image_plan.master_plan.source_path}"
          )

          image_master_relative_path =
            Path.join(
              target_relative_path,
              Path.basename(image_plan.master_plan.destination_path)
            )

          image_thumbnail_relative_path =
            Path.join(
              target_relative_path,
              Path.basename(image_plan.thumbnail_plan.destination_path)
            )

          image_mini_thumbnail_relative_path =
            Path.join(
              target_relative_path,
              Path.basename(image_plan.mini_thumbnail_plan.destination_path)
            )

          {exif_map, creation_datetime} = get_image_exif(image_plan.master_plan.source_path, now)

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

  defp create_image_master(%ImageMasterPlan{} = image_plan) do
    case image_plan.action do
      :safe_copy ->
        File.safe_copy(image_plan.source_path, image_plan.destination_path)

      :convert_to_webp_lossy ->
        Convert.to_webp_lossy(image_plan.source_path, image_plan.destination_path)

      :convert_to_webp_lossless ->
        Convert.to_webp_lossless(image_plan.source_path, image_plan.destination_path)
    end
  end

  defp create_thumbnail(%ImageThumbnailPlan{} = thumbnail_plan) do
    case thumbnail_plan.action do
      :safe_copy ->
        File.safe_copy(thumbnail_plan.source_path, thumbnail_plan.destination_path)

      _ ->
        Convert.resize_image(
          thumbnail_plan.source_path,
          thumbnail_plan.destination_path,
          thumbnail_plan.size
        )
    end
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
