defmodule Artour.ApiFormatView do
  use Artour.Web, :view

  alias Artour.ApiFormatView

  @doc """
  Renders list of formats
  """
  def render("index.json", %{formats: formats}) do
    %{data: render_many(formats, ApiFormatView, "format.json")}
  end

  def render("format.json", %{api_format: format}) do
    %{id: format.id,
      name: format.name,
    }
  end
end
