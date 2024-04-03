defmodule PhotogWeb.PageController do
  use PhotogWeb, :controller

  def index(conn, _params) do
    image_url_prefix = Application.fetch_env!(:photog, :image_url_prefix)
    
    render conn, "index.html", csrf_token: get_csrf_token(), image_url_prefix: image_url_prefix
  end
end
