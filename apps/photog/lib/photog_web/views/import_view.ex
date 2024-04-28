defmodule PhotogWeb.ImportView do
  use PhotogWeb, :view
  alias PhotogWeb.ImportView
  alias Common.DateHelpers

  def import_name(import) do
    DateHelpers.us_formatted_date(import.import_time)
    <> " "
    <> DateHelpers.formatted_time(import.import_time)
  end

  def render("index.json", %{imports: imports}) do
    %{data: render_many(imports, ImportView, "import_excerpt.json")}
  end

  def render("index_with_count_and_images.json", %{imports: imports, albums_map: albums_map}) do
    %{data: Enum.map(imports, fn import ->
      %{
        id: import.id,
        import_time: import.import_time,
        name: import_name(import),
        notes: import.notes,
        camera_model: import.camera_model,
        images_count: import.images_count,
        images: Enum.map(import.images, &PhotogWeb.ImageView.image_thumbnail_to_map/1),
        albums: albums_map[import.id],
      }
    end)
    }
  end

  def render("show.json", %{import: import}) do
    %{data: render_one(import, ImportView, "import.json")}
  end

  def render("import_excerpt.json", %{import: import}) do
    import_excerpt_to_map(import)
  end

  def render("import.json", %{import: import}) do
    %{
      id: import.id,
      import_time: import.import_time,
      name: import_name(import),
      cover_image_id: import.cover_image_id,
      notes: import.notes,
      images_count: import.images_count,
    }
  end

  def import_excerpt_to_map(import) do
    %{
      id: import.id,
      import_time: import.import_time,
      name: import_name(import),
      notes: import.notes,
    }
  end
end
