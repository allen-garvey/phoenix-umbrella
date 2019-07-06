defmodule Artour.ApiImageController do
  use Artour.Web, :controller

  alias Artour.Api

  @doc """
  Creates image resources from given array
  """
  def create_many(conn, %{"images" => images}) do
    case Api.create_images(images) do
      {:error, errors} -> render(conn, "errors.json", errors: errors)
      _                -> send_resp(conn, 200, "{\"data\": \"ok\"}")
    end
  end

end
