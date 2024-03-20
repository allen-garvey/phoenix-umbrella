defmodule PhotogWeb.SettingsController do
    use PhotogWeb, :controller
  
    action_fallback PhotogWeb.FallbackController
  
    def index(conn, _params) do
      image_url_prefix = Application.fetch_env!(:photog, :image_url_prefix)
      render(conn, "index.json", image_url_prefix: image_url_prefix)
    end
end
  