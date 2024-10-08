defmodule BlockquoteWeb.Router do
  use BlockquoteWeb, :router

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

  scope "/", BlockquoteWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", AdminController, :index
  end

  scope "/admin", BlockquoteWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", AdminController, :index

    resources "/authors", AuthorController
    resources "/categories", CategoryController
    resources "/source-types", SourceTypeController
    resources "/parent-sources", ParentSourceController
    resources "/sources", SourceController
    resources "/quotes", QuoteController
    resources "/daily-quotes", DailyQuoteController
  end

  scope "/api", BlockquoteWeb do
    pipe_through :api
    pipe_through :authenticate

    get "/daily-quote", ApiDailyQuoteController, :get_daily_quote
  end
end
