defmodule PhotogWeb.Router do
  use PhotogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  pipeline :authenticate do
    plug GrenadierWeb.Plugs.Authenticate
  end

  # Other scopes may use custom stacks.
  scope "/api", PhotogWeb do
    pipe_through :api
    pipe_through :authenticate

    #has to be here so it doesn't conflict with import show route
    get "/imports/last", ImportController, :show_last

    resources "/images", ImageController,               only: [:index, :show, :update]
    resources "/albums", AlbumController
    resources "/persons", PersonController
    resources "/person_images", PersonImageController,  only: [:index, :show, :create]
    resources "/album_images", AlbumImageController,    only: [:index, :show, :create]
    resources "/imports", ImportController,             only: [:index, :show]
    resources "/tags", TagController
    resources "/album_tags", AlbumTagController,        only: [:index, :show, :create]

    get "/images/:id/exif", ImageController, :exif_for

    # Reorder album images
    patch "/albums/:id/images/reorder",       AlbumController, :reorder_images

    # Replace album tags
    put "/albums/:id/tags",                   AlbumController, :replace_tags

    # Reorder album tags
    patch "/tags/:id/albums/reorder",         TagController, :reorder_albums

    # Edit album images
    get "/images/:id/albums",                 ImageController, :albums_for
    post "/images/:id/albums",                ImageController, :add_albums
    delete "/images/:id/albums/:album_id",    ImageController, :remove_album

    # Edit person images
    get "/images/:id/persons",                ImageController, :persons_for
    post "/images/:id/persons",               ImageController, :add_persons
    delete "/images/:id/persons/:person_id",  ImageController, :remove_person
  end

  scope "/", PhotogWeb do
    pipe_through :browser
    pipe_through :authenticate

    # catch all requests and send index page for single page application
    # note this has to be the last route, since routes declared after this one won't be triggered
    # https://elixirforum.com/t/how-to-change-routes-for-single-page-application/3954
    get "/*path", PageController, :index
  end
end
