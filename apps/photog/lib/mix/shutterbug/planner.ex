defmodule Photog.Shutterbug.Planner do
  alias Photog.Shutterbug.File
  alias Photog.Shutterbug.Image
  alias Photog.Shutterbug.ImagePlan
  alias Photog.Shutterbug.ImageMasterPlan
  alias Photog.Shutterbug.ImageThumbnailPlan

  def make_plan_for_images(image_files, masters_path, thumbnails_path, convert_to_webp)
      when is_boolean(convert_to_webp) do
    directory_prefix_map = File.get_directory_prefix_map(image_files)

    image_files
    |> Enum.map(fn image_file ->
      %ImagePlan{
        master_plan:
          get_image_master_plan(image_file, directory_prefix_map, masters_path, convert_to_webp),
        thumbnail_plan:
          get_image_thumbnail_plan(image_file, directory_prefix_map, thumbnails_path),
        mini_thumbnail_plan:
          get_image_mini_thumbnail_plan(image_file, directory_prefix_map, thumbnails_path)
      }
    end)
  end

  defp get_image_master_plan(
         image_source_path,
         directory_prefix_map,
         masters_path,
         convert_to_webp
       ) do
    action = get_image_master_action_for(image_source_path, convert_to_webp)

    %ImageMasterPlan{
      action: action,
      source_path: image_source_path,
      destination_path:
        image_master_destination_path_for(
          image_source_path,
          directory_prefix_map,
          masters_path,
          action
        )
    }
  end

  def get_image_master_action_for(image_source_path, convert_to_webp)
      when is_boolean(convert_to_webp) do
    extension = Path.extname(image_source_path)

    cond do
      Enum.member?([".webp", ".svg"], extension) ->
        :safe_copy

      extension == ".png" ->
        :convert_to_webp_lossless

      convert_to_webp || extension == ".heic" ->
        :convert_to_webp_lossy

      true ->
        :safe_copy
    end
  end

  def image_master_destination_path_for(
        image_source_path,
        directory_prefix_map,
        masters_path,
        action
      ) do
    case action do
      :safe_copy ->
        File.file_path_with_prefix(directory_prefix_map, image_source_path, masters_path)

      _ ->
        Path.join(
          masters_path,
          Image.webp_name(File.add_prefix_to_file(directory_prefix_map, image_source_path))
        )
    end
  end

  defp get_image_thumbnail_plan(image_source_path, directory_prefix_map, thumbnails_path) do
    action =
      case Path.extname(image_source_path) do
        ".svg" -> :safe_copy
        _ -> :resize
      end

    destination_path =
      case action do
        :safe_copy ->
          File.file_path_with_prefix(directory_prefix_map, image_source_path, thumbnails_path)

        _ ->
          Path.join(
            thumbnails_path,
            File.add_prefix_to_file(directory_prefix_map, image_source_path)
            |> Image.thumbnail_name()
          )
      end

    %ImageThumbnailPlan{
      action: action,
      source_path: image_source_path,
      destination_path: destination_path,
      size: 768
    }
  end

  defp get_image_mini_thumbnail_plan(image_source_path, directory_prefix_map, thumbnails_path) do
    destination_path =
      Path.join(
        thumbnails_path,
        File.add_prefix_to_file(directory_prefix_map, image_source_path)
        |> Image.mini_thumbnail_name()
      )

    %ImageThumbnailPlan{
      action: :resize,
      source_path: image_source_path,
      destination_path: destination_path,
      size: 300
    }
  end
end
