defmodule SerenWeb.FileTypeView do
  use SerenWeb, :view
  alias SerenWeb.FileTypeView

  def render("index.json", %{file_types: file_types}) do
    %{data: render_many(file_types, FileTypeView, "file_type.json")}
  end

  def render("show.json", %{file_type: file_type}) do
    %{data: render_one(file_type, FileTypeView, "file_type.json")}
  end

  def render("file_type.json", %{file_type: file_type}) do
    %{id: file_type.id,
      name: file_type.name}
  end
end
