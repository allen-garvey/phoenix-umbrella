defmodule PhotogWeb.PersonView do
  use PhotogWeb, :view
  alias PhotogWeb.PersonView

  def render("index.json", %{persons: persons}) do
    %{data: Enum.map(persons, &person_excerpt_to_map/1)}
  end

  def render("index_excerpt.json", %{persons: persons}) do
    %{data: Enum.map(persons, &person_excerpt_mini_to_map/1)}
  end

  def render("show.json", %{person: person}) do
    %{data: render_one(person, PersonView, "person.json")}
  end

  def render("show_excerpt_mini.json", %{person: person}) do
    %{data: 
      %{
        id: person.id,
        name: person.name,
        is_favorite: person.is_favorite,
      }
    }
  end

  def render("person.json", %{person: person}) do
    %{
      id: person.id,
      name: person.name,
      is_favorite: person.is_favorite,
      cover_image: PhotogWeb.ImageView.image_to_map(person.cover_image),
      images_count: person.images_count,
    }
  end

  def person_excerpt_to_map(person) do
    %{
      id: person.id,
      name: person.name,
      items_count: person.images_count,
      is_favorite: person.is_favorite,
      cover_image: %{
        mini_thumbnail_path: person.cover_image.mini_thumbnail_path
      },
    }
  end

  def person_excerpt_mini_to_map(person) do
    %{
      id: person.id,
      name: person.name,
      is_favorite: person.is_favorite,
    }
  end
end
