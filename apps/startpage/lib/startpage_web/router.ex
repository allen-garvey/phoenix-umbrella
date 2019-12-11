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

  # based on:
  # http://www.cultivatehq.com/posts/how-to-set-different-layouts-in-phoenix/
  pipeline :admin_layout do
    plug :put_layout, {StartpageWeb.LayoutView, :admin}
  end

  scope "/", StartpageWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", PageController, :index
  end

  scope "/admin", StartpageWeb do
    pipe_through :browser
    pipe_through :authenticate
    pipe_through :admin_layout

    get "/", FolderController, :index

    resources "/folders", FolderController
  end

  # Other scopes may use custom stacks.
  # scope "/api", StartpageWeb do
  #   pipe_through :api
  # end
end
