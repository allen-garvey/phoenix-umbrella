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

  pipeline :admin_layout do
    plug :put_layout, {GrenadierWeb.LayoutView, :app}
  end

  pipeline :authenticate do
    plug GrenadierWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :supersearch_app_layout do
    plug :put_layout, {SupersearchWeb.LayoutView, :app}
  end

  scope "/admin", SupersearchWeb, host: "search." do
    pipe_through :browser
    pipe_through :authenticate
    pipe_through :supersearch_app_layout

    get "/", EngineController, :index

    resources "/engines", EngineController
  end

  scope "/", SupersearchWeb, host: "search." do
    pipe_through :browser
    pipe_through :supersearch_app_layout

    get "/", PageController, :index
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
    pipe_through :admin_layout

    get "/", PageController, :index

    resources "/users", UserController, only: [:index, :show]
    resources "/logins", LoginController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", GrenadierWeb do
  #   pipe_through :api
  # end
end
