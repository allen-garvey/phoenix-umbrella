defmodule Bookmarker.Router do
  use Bookmarker.Web, :router

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

  pipeline :fetch_favorite_folders do
    plug Bookmarker.Plugs.FetchFavoriteFolders
  end

  scope "/", Bookmarker do
    pipe_through :browser
    pipe_through :authenticate
    pipe_through :fetch_favorite_folders

    get "/", PageController, :index
    resources "/folders", FolderController
    resources "/bookmarks", BookmarkController
    resources "/tags", TagController
    resources "/bookmarks_tags", BookmarkTagController

    get "/preview/folder:folder_name", FolderPreviewController, :show
  end

  #JSON API
  scope "/api", Bookmarker do
    pipe_through :api
    pipe_through :authenticate

    # get "/folders", ApiFolderController, :index
    get "/folders/:folder_id/bookmarks", ApiFolderController, :bookmarks_for_folder
    get "/bookmarks/:bookmark_id/tags", ApiTagController, :tags_for_bookmark
    get "/bookmarks/:bookmark_id/tags/unused", ApiTagController, :unused_tags_for_bookmark
    post "/bookmarks_tags/", ApiBookmarkTagController, :create_bookmark_tag
    delete "/bookmarks_tags/", ApiBookmarkTagController, :delete_bookmark_tag
  end
end
