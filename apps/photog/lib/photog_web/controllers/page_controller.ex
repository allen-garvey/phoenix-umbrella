defmodule PhotogWeb.PageController do
  use PhotogWeb, :controller

  def index(conn, _params) do
    image_url_prefix = Application.fetch_env!(:photog, :image_url_prefix)
    image_thumbnails_only = Application.fetch_env!(:photog, :image_thumbnails_only)
    b2_bucket_prefix = Application.fetch_env!(:photog, :b2_bucket_prefix)
    
    render(conn, "index.html", csrf_token: get_csrf_token(), image_url_prefix: image_url_prefix, image_thumbnails_only: image_thumbnails_only, b2_bucket_prefix: b2_bucket_prefix)
  end
end
