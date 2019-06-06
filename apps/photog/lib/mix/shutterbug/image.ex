defmodule Photog.Shutterbug.Image do

  alias Photog.Repo
  alias Photog.Api.Image

  def thumbnail_name(image_name) do
    "thumb_#{Path.rootname(image_name)}.jpg"
  end

  def mini_thumbnail_name(image_name) do
    "thumb_mini_#{Path.rootname(image_name)}.jpg"
  end

  def create_image!(attrs) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert!
  end

end
