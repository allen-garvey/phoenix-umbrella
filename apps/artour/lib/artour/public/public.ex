defmodule Artour.Public do
  @moduledoc """
  The Public context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Artour.Post
  # alias Artour.Image
  alias Artour.PostImage

  @doc """
  Returns the list of posts.
  """
  def list_posts do
    from(p in Post, where: p.is_published == true, order_by: [desc: :publication_date, desc: :id])
    |> Repo.all
  end


  @doc """
  Gets a single post by slug

  Raises `Ecto.NoResultsError` if the Post does not exist.
  """
  def get_post_by_slug!(slug) do
    from(
          post in Post,
          join: cover_image in assoc(post, :cover_image),
          where: post.slug == ^slug and post.is_published == true,
          preload: [cover_image: cover_image]
        )
    |> Repo.one!
    |> Repo.preload(post_images: from(pi in PostImage, join: image in assoc(pi, :image), preload: [image: image], order_by: [pi.order, pi.id]))
  end

  @doc """
  Returns posts for homepage
  """
  def posts_for_homepage do
    from(
          p in Post,
          join: cover_image in assoc(p, :cover_image),
          where: p.is_published == true,
          preload: [cover_image: cover_image],
          order_by: [desc: :publication_date, desc: :id]
        )
    |> Repo.all
  end

end
