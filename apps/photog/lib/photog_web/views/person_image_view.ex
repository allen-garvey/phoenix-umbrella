defmodule PhotogWeb.PersonImageView do
  use PhotogWeb, :view
  alias PhotogWeb.PersonImageView

  def render("index.json", %{person_images: person_images}) do
    %{data: render_many(person_images, PersonImageView, "person_image.json")}
  end

  def render("show.json", %{person_image: person_image}) do
    %{data: render_one(person_image, PersonImageView, "person_image.json")}
  end

  def render("person_image.json", %{person_image: person_image}) do
    %{id: person_image.id,
      person_id: person_image.person_id,
      image_id: person_image.image_id,
    }
  end
end
