defmodule StartpageWeb.Router do
  use StartpageWeb, :router

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

  pipeline :authenticate do
    plug GrenadierWeb.Plugs.Authenticate
  end

  scope "/", StartpageWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", PageController, :index
  end

  scope "/admin", StartpageWeb do
    pipe_through :browser
    pipe_through :authenticate

    resources "/folders", FolderController
  end

  # Other scopes may use custom stacks.
  # scope "/api", StartpageWeb do
  #   pipe_through :api
  # end
end
