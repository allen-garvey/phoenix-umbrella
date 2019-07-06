defmodule Artour.ApiErrorView do
  use Artour.Web, :view

  @doc """
  Renders single api error
  """
  def render("error.json", %{api_error: _error}) do
    %{
      message: "error"
    }
  end
end
