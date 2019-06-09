defmodule MovielistWeb.Router do
  use MovielistWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MovielistWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/movies/active", MovieController, :index_active #has to be before resources or conflicts with show pages
    get "/movies/suggestions", MovieController, :index_suggestions #has to be before resources or conflicts with show pages

    get "/reports/:year", ReportsController, :show

    resources "/genres", GenreController
    resources "/movies", MovieController
    resources "/ratings", RatingController

    get "/movies/:movie_id/ratings/new", RatingController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", MovielistWeb do
  #   pipe_through :api
  # end
end
