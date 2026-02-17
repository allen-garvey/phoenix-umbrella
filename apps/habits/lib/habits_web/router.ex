defmodule HabitsWeb.Router do
  use HabitsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, {HabitsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

    get "/", CategoryController, :create_category_activity_index
    get "/calendar", PageController, :calendar
    get "/categories/:id/activities", CategoryController, :activities_list
    get "/categories/:id/summary", CategoryController, :summary
    get "/activities/search", ActivityController, :search

    resources "/activities", ActivityController
    resources "/categories", CategoryController
    resources "/tags", TagController
  end

  scope "/api", HabitsWeb do
    pipe_through :api
    pipe_through :authenticate

    get "/activities", ApiActivityController, :index
    get "/categories", ApiCategoryController, :index
    get "/categories/:id/tags", ApiTagController, :tags_for_category
  end
end
