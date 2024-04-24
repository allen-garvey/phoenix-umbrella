defmodule Artour.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Artour.Post
  alias Artour.PostTag
  alias Artour.Image
  # alias Artour.PostImage

  @doc """
  Returns the list of posts.
  """
  def list_posts do
    from(
          p in Post,
          join: cover_image in assoc(p, :cover_image),
          preload: [cover_image: cover_image],
          order_by: [desc: :id]
        )
    |> Repo.all
  end


  @doc """
  Gets a single post by id

  Raises `Ecto.NoResultsError` if the Post does not exist.
  """
  def get_post_for_show!(id) do
    from(
          post in Post,
          left_join: tag in assoc(post, :tags),
          where: post.id == ^id,
          preload: [tags: tag],
          order_by: [tag.name]
        )
    |> Repo.one!
  end

  @doc """
  Returns the list of images.
  """
  def list_images do
    from(
          Image,
          order_by: [desc: :id]
        )
    |> Repo.all
  end

  @doc """
  Returns a single image selected by image_id
  """
  def get_image!(image_id) do
    from(
          i in Image,
          where: i.id == ^image_id,
          limit: 1
    )
    |> Repo.one!
  end

   @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{source: %Image{}}
  """
  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end

  @doc """
  Deletes a single post_tag, given post_id and tag_id
  """
  def delete_post_tag(post_id, tag_id) do
    #use transaction to ensure only 1 row gets deleted
    Repo.transaction(fn ->
      {1, nil} = from(pt in PostTag, where: pt.post_id == ^post_id and pt.tag_id ==^tag_id)
      |> Repo.delete_all()
    end)
  end

end
