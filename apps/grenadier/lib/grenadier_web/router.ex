defmodule GrenadierWeb.Router do
  use GrenadierWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_secure do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GrenadierWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GrenadierWeb do
    pipe_through :browser

    get "/", PageController, :login

    get "/login", PageController, :login
    post "/login", PageController, :login_submit
  end

  scope "/admin", GrenadierWeb do
    pipe_through :browser_secure

    # get "/", UserController, :index

    resources "/users", UserController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", GrenadierWeb do
  #   pipe_through :api
  # end
end
