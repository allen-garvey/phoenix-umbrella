defmodule PluginistaWeb.Router do
  use PluginistaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
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
    get "/reports/makers", ReportController, :makers_index

    resources "/categories", CategoryController
    resources "/groups", GroupController
    resources "/makers", MakerController
    resources "/plugins", PluginController
    resources "/plugin_categories", PluginCategoryController

    post "/plugins/:id/update_categories", PluginController, :update_categories
  end

  scope "/api", PluginistaWeb do
    pipe_through :api

    get "/categories", ApiCategoryController, :index
    get "/groups", ApiGroupController, :index
    get "/makers", ApiMakerController, :index
    get "/plugins", ApiPluginController, :index

    get "/categories/:id/plugins", ApiPluginController, :plugins_for_category
    get "/groups/:id/plugins", ApiPluginController, :plugins_for_group
    get "/makers/:id/plugins", ApiPluginController, :plugins_for_maker

    get "/reports/makers", ApiReportController, :makers_index
  end
end
