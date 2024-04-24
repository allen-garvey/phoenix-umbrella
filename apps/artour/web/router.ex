defmodule Artour.Router do
  use Artour.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  #no need for CSRF protection, sessions or flash
  #since we are just viewing pages
  pipeline :public_browser do
    plug :accepts, ["html"]
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

  # based on:
  # http://www.cultivatehq.com/posts/how-to-set-different-layouts-in-phoenix/
  pipeline :public_layout do
    plug :put_layout, {Artour.LayoutView, :public}
  end

  # public site
  scope "/", Artour do
    pipe_through [:public_browser, :public_layout]

    get "/", PageController, :index

    get "/404.html", PageController, :error_404

    get "/tags", PublicTagController, :index
    get "/tags/:slug", PublicTagController, :show

    get "/posts", PublicPostController, :index
    get "/posts/:slug", PublicPostController, :show
  end

  #Admin site
  scope "/admin", Artour do
    pipe_through :browser
    pipe_through :authenticate

    get "/", AdminController, :index

    #displays form to add images to post
    get "/posts/:post/images/add", PostController, :add_images
    post "/posts/:post/images", PostController, :save_images

    resources "/posts", PostController
    resources "/images", ImageController
    resources "/post_images", PostImageController
    resources "/tags", TagController
    resources "/post_tags", PostTagController
  end

  # Other scopes may use custom stacks.
  scope "/admin/api", Artour do
    pipe_through :api
    pipe_through :authenticate

    #edit post tags
    get "/posts/:post_id/tags", ApiPostController, :tags_for
    patch "/posts/:post_id", ApiPostController, :update
    post "/posts/:post_id/tags", ApiPostController, :add_tags
    delete "/posts/:post_id/tags/:tag_id", ApiPostController, :remove_tag

    #reorder post images
    get "/posts/:post_id/images", ApiPostController, :post_images
    patch "/posts/:post_id/images/reorder", ApiPostController, :reorder_images

    #add images to post
    get "/posts/:post/images/addable", ApiPostController, :addable_images
  end
end
