defmodule GrenadierWeb.Router do
  use GrenadierWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :bare_layout do
    plug :put_layout, {GrenadierWeb.LayoutView, :bare}
  end

  pipeline :authenticate do
    plug GrenadierWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GrenadierWeb do
    pipe_through :browser
    pipe_through :bare_layout

    get "/", PageController, :login

    get "/login", PageController, :login
    post "/login", PageController, :login_submit

    get "/logout", PageController, :logout
  end

  scope "/admin", GrenadierWeb do
    pipe_through :browser
    pipe_through :authenticate

    # get "/", UserController, :index

    resources "/users", UserController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", GrenadierWeb do
  #   pipe_through :api
  # end
end
