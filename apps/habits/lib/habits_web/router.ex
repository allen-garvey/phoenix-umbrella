defmodule HabitsWeb.Router do
  use HabitsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, {HabitsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HabitsWeb.Plugs.FetchFavoriteCategories
  end

  pipeline :authenticate do
    plug GrenadierWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  scope "/", HabitsWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", PageController, :index

    get "/categories/:id/activities", CategoryController, :activities_list

    resources "/activities", ActivityController
    resources "/categories", CategoryController
  end

  scope "/api", HabitsWeb do
    pipe_through :api
    pipe_through :authenticate

    get "/activities", ApiActivityController, :index
    get "/categories", ApiCategoryController, :index
  end
end
