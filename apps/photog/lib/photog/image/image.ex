defmodule Photog.Image do
  alias Photog.Api.Image

  def masters_directory do
    Path.expand("../../../priv/static/media/images", __DIR__)
  end

  def thumbnails_directory do
    Path.expand("../../../priv/static/media/thumbnails", __DIR__)
  end

  def master_file_path(%Image{} = image) do
    masters_directory()
    |> Path.join(image.master_path)
  end
end
