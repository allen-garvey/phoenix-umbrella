defmodule BooklistWeb.Router do
  use BooklistWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  pipeline :authenticate do
    plug GrenadierWeb.Plugs.Authenticate
  end

  scope "/", BooklistWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", PageController, :index
    get "/resources", PageController, :resources
    get "/bookshelf", PageController, :bookshelf

    resources "/authors", AuthorController
    resources "/books", BookController
    resources "/book-locations", BookLocationController
    resources "/genres", GenreController
    resources "/libraries", LibraryController
    resources "/loans", LoanController
    resources "/locations", LocationController
    resources "/ratings", RatingController

    # routes with duplicate methods have to be after resource routes, or they cause errors on index pages
    get "/books/:book_id/locations/new", BookLocationController, :new
    get "/books/:book_id/ratings/new", RatingController, :new
    get "/books/:id/duplicate", BookController, :duplicate

    get "/libraries/:library_id/locations/new", LocationController, :new
  end

  scope "/reports", BooklistWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", ReportsController, :index
    get "/years", ReportsController, :years_index
    get "/years/:year", ReportsController, :years_show
    get "/authors", ReportsController, :authors_index
    get "/genres", ReportsController, :genres_index
    get "/reread-books", ReportsController, :reread_books_index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BooklistWeb do
  #   pipe_through :api
  # end
end
