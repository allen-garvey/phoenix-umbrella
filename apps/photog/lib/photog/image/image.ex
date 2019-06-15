defmodule Photog.Image do
  alias Photog.Api.Image

  def masters_directory do
    Path.absname("apps/photog/priv/static/media/images")
  end

  def thumbnails_directory do
    Path.absname("apps/photog/priv/static/media/thumbnails")
  end

  def master_file_path(%Image{} = image) do
    masters_directory()
    |> Path.join(image.master_path)
  end
end
