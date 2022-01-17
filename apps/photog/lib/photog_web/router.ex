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

    # has to be here so it doesn't conflict with import show route
    get "/imports/last",  ImportController, :show_last
    get "/albums/count",  AlbumController,  :count
    get "/images/count",  ImageController,  :count
    get "/imports/count", ImportController, :count

    resources "/images", ImageController,               only: [:index, :show, :update]
    resources "/albums", AlbumController
    resources "/persons", PersonController
    resources "/person_images", PersonImageController,  only: [:index, :show, :create]
    resources "/album_images", AlbumImageController,    only: [:index, :show, :create]
    resources "/imports", ImportController,             only: [:index, :show, :update]
    resources "/tags", TagController
    resources "/album_tags", AlbumTagController,        only: [:index, :show, :create]

    # Images
    get "/images/:id/exif",           ImageController, :exif_for
    get "/images/years/:year",        ImageController, :images_for_year
    get "/images/years/:year/count",  ImageController, :images_for_year_count

    # Albums
    get "/albums/years/:year",        AlbumController, :albums_for_year
    get "/albums/years/:year/count",  AlbumController, :albums_for_year_count

    # Items for model
    get "/albums/:id/images",                 AlbumController,  :images_for
    get "/persons/:id/images",                PersonController, :images_for
    get "/imports/:id/images",                ImportController, :images_for
    get "/tags/:id/albums",                   TagController,    :albums_for

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
    delete "/albums/:id/images",              AlbumController, :remove_images_from_album

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
