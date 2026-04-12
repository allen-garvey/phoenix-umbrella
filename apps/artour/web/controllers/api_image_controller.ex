defmodule Artour.ApiImageController do
  use Artour.Web, :controller
  plug(:put_view, json: Artour.ApiImageView)
end
