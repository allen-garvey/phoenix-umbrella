defmodule SerenWeb.Router do
  use SerenWeb, :router

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

  scope "/api", SerenWeb do
    pipe_through :api

    resources "/tracks",      TrackController,    only: [:index, :show]
    resources "/artists",     ArtistController,   only: [:index, :show]
    resources "/genres",      GenreController,    only: [:index, :show]
    resources "/composers",   ComposerController, only: [:index, :show]
    resources "/file_types",  FileTypeController, only: [:index, :show]
    resources "/albums",      AlbumController,    only: [:index, :show]

    get "/artists/:id/tracks",    ArtistController,   :tracks_for
    get "/genres/:id/tracks",     GenreController,    :tracks_for
    get "/composers/:id/tracks",  ComposerController, :tracks_for
    get "/albums/:id/tracks",     AlbumController, :tracks_for
    get "/search/tracks",         SearchController,    :tracks_for
  end

  scope "/", SerenWeb do
    pipe_through :browser # Use the default browser stack

    # catch all requests and send index page for single page application
    # note this has to be the last route, since routes declared after this one won't be triggered
    # https://elixirforum.com/t/how-to-change-routes-for-single-page-application/3954
    get "/*path", PageController, :index
  end

end
