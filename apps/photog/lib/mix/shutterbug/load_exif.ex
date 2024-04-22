defmodule Mix.Tasks.Shutterbug.LoadExif do
  use Mix.Task

  import Ecto.Query, warn: false
  alias Grenadier.Repo
  alias Photog.Image.Exif
  alias Photog.Api.Image
  alias Photog.Api

  @moduledoc """
  Updates all saved images with no values in the exif column with the exif data found in the image's master path file
  """
  @doc """
  Updates all saved images with no values in the exif column with the exif data found in the image's master path file
  """
  def run(_args) do
    load_exif()
  end

  @doc """
  Imports image files from directory
  """
  def load_exif do
    # disable ecto database logging
    Logger.configure(level: :error)
    # start app so repo is available
    Mix.Task.run "app.start", []

    images = from(i in Image, where: is_nil(i.exif))
      |> Repo.all
    images_length = Enum.count(images)

    for { image, index } <- Enum.with_index(images) do
      IO.puts "Loading exif for image #{index+1}/#{images_length}"
      exif_map = Exif.exif_for(image)
      image_params = %{"exif" => exif_map}
      case Api.update_image(image, image_params) do
        {:ok, %Image{} = _image} -> true
        _ -> IO.puts "Exif update failed for image #{image.id} #{image.master_path}"
      end
    end

  end
end
