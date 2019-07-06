defmodule Artour.ApiFormatController do
  use Artour.Web, :controller

  alias Artour.Admin

  def index(conn, _params) do
    formats = Admin.list_formats()
    render(conn, "index.json", formats: formats)
  end

end
