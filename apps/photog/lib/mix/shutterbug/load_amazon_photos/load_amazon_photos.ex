defmodule Mix.Tasks.Shutterbug.LoadAmazonPhotos do
  use Mix.Task

  alias Photog.Shutterbug
  alias Common.MixHelpers.Error

  @moduledoc """
  Given a json file saved from Amazon photos api response, will add Amazon photo ids
  to image resources
  """
  @doc """
  Imports images from source directory to (optional) destination directory. If no directory given, will default to ./priv/static/media, or separate masters and thumbnail destination directories can be given
  """
  def run([json_file_path, folder_name]) do
    case File.read(json_file_path) do
      {:ok, data} -> Jason.decode!(data) |> add_amazon_photo_ids(folder_name)
      {:error, reason} -> file_read_error(reason, json_file_path)
    end
  end

  def run(_args) do
  	Error.exit_with_error("usage: mix shutterbug.load_amazon_photos <json_file_path> <import_folder_name>")
  end

  def file_read_error(reason, file_path) do
    "#{:file.format_error(reason)} #{file_path}"
    |> Error.exit_with_error()
  end

  @doc """
  Adds Amazon Photos ids to image resources
  """
  def add_amazon_photo_ids(api_json, folder_name) do
    # disable logging of database queries
    Logger.configure(level: :error)
    #start app so repo is available
    Mix.Task.run "app.start", []

    count_of_images_before = Shutterbug.get_count_of_images_with_amazon_photos_id()

    for image_json <- api_json["data"] do
      amazon_id = image_json["id"]
      masters_filename = "#{folder_name}/#{image_json["name"]}"

      Shutterbug.add_amazon_photos_id(amazon_id, masters_filename)
    end

    count_of_images_after = Shutterbug.get_count_of_images_with_amazon_photos_id()

    IO.puts "#{count_of_images_before} images with Amazon Photos id before now #{count_of_images_after} #{count_of_images_after - count_of_images_before} images updated"

  end
end
