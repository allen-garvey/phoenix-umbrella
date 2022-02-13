defmodule Photog.Shutterbug.Image do

  alias Photog.Repo
  alias Photog.Api.Image

  def webp_name(image_name) do
    "#{Path.rootname(image_name)}.webp"
  end

  def thumbnail_name(image_name) do
    "thumb_#{webp_name(image_name)}"
  end

  def mini_thumbnail_name(image_name) do
    "thumb_mini_#{webp_name(image_name)}"
  end

  def create_image!(attrs) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert!
  end

end
