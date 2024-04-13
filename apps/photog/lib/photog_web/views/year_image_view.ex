defmodule PhotogWeb.YearImageView do
  use PhotogWeb, :view
  alias PhotogWeb.YearImageView

  def render("index.json", %{year_images: year_images}) do
    %{data: render_many(year_images, YearImageView, "year_image.json")}
  end

  def render("show.json", %{year_image: year_image}) do
    %{data: render_one(year_image, YearImageView, "year_image.json")}
  end

  def render("year_image.json", %{year_image: year_image}) do
    %{
      id: year_image.id,
      year: year_image.year
    }
  end
end
