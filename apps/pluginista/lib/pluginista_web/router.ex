defmodule PluginistaWeb.Router do
  use PluginistaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PluginistaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PluginistaWeb.Plugs.ResourcesForNav
  end

  pipeline :authenticate do
    plug GrenadierWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PluginistaWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", PageController, :index

    get "/reports", ReportController, :index

    resources "/categories", CategoryController
    resources "/groups", GroupController
    resources "/makers", MakerController
    resources "/plugins", PluginController
    resources "/plugin_categories", PluginCategoryController

    post "/plugins/:id/update_categories", PluginController, :update_categories
  end

  # Other scopes may use custom stacks.
  # scope "/api", PluginistaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

    # scope "/" do
    #   pipe_through :browser

    #   live_dashboard "/dashboard", metrics: PluginistaWeb.Telemetry
    # end
  # end
end
