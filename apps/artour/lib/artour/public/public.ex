defmodule Artour.Public do
  @moduledoc """
  The Public context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Artour.Post
  alias Artour.Tag
  alias Artour.Category
  # alias Artour.Image
  alias Artour.PostImage
  # alias Artour.PostTag

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
          join: category in assoc(post, :category),
          join: cover_image in assoc(post, :cover_image),
          left_join: tag in assoc(post, :tags),
          where: post.slug == ^slug and post.is_published == true,
          preload: [category: category, cover_image: cover_image, tags: tag],
          order_by: [tag.name]
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

  @doc """
  Returns list of all tags associated with at least 1 (published) post
  """
  def tags_with_posts() do
    # need to use distinct name instead of id so order by works
    # since names have to be unique we can do this, otherwise we would need to find another way
    # https://stackoverflow.com/questions/5391564/how-to-use-distinct-and-order-by-in-same-select-statement
    from(
          t in Tag,
          join: post in assoc(t, :posts),
          where: post.is_published == true,
          distinct: t.name,
          order_by: [t.name]
        )
    |> Repo.all
  end

  @doc """
  Gets a single tag by slug

  Raises `Ecto.NoResultsError` if the Tag does not exist or has no published posts
  """
  def get_tag_by_slug!(slug) do
    from(
          t in Tag,
          join: post in assoc(t, :posts),
          where: t.slug == ^slug and post.is_published == true,
          preload: [posts: post],
          order_by: post.title
        )
    |> Repo.one!
  end

  @doc """
  Returns list of all categories associated with at least 1 (published) post
  """
  def categories_with_posts() do
    # need to use distinct name instead of id so order by works
    # since names have to be unique we can do this, otherwise we would need to find another way
    # https://stackoverflow.com/questions/5391564/how-to-use-distinct-and-order-by-in-same-select-statement
    from(
          c in Category,
          join: post in assoc(c, :posts),
          where: post.is_published == true,
          distinct: c.name,
          order_by: [c.name]
        )
    |> Repo.all
  end

  @doc """
  Gets a single category by slug

  Raises `Ecto.NoResultsError` if the Category does not exist or has no published posts
  """
  def get_category_by_slug!(slug) do
    from(
          c in Category,
          join: post in assoc(c, :posts),
          where: c.slug == ^slug and post.is_published == true,
          preload: [posts: post],
          order_by: post.title
        )
    |> Repo.one!
  end

end
