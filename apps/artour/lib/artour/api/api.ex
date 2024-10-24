defmodule Artour.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo
  alias Artour.Admin

  alias Artour.Post
  alias Artour.Image
  alias Artour.PostImage

  @doc """
  Returns the list of a post's post images
  """
  def list_post_images_for_post(post_id) do
    from(
          pi in PostImage,
          join: image in assoc(pi, :image),
          preload: [image: image],
          where: pi.post_id == ^post_id,
          order_by: [pi.order, pi.id]
        )
    |> Repo.all
  end

  @doc """
  Creates images
  returns [changeset|nil] array of changesets for images with errors, or nil if image has no errors
  if successful, will return whatever Repo.transaction returns, which I believe is nil
  """
  def create_images(images) do
    Repo.transaction(fn ->
      {status, errors} = Enum.reduce(images, {:ok, []}, fn image, {status, errors} ->
        case Admin.create_image(image) do
          {:ok, %Image{} = _image} -> {status, [nil | errors]}
          {:error, changeset}      -> {:error, [changeset | errors]}
        end
      end)
      if status == :error do
        Enum.reverse(errors)
        |> Repo.rollback
      end
    end)
  end

  @doc """
  Reorder images for post
  """
  def reorder_post_images(post_images) when is_list(post_images) do
    Repo.transaction(fn ->
      for {post_image_id, i} <- post_images |> Enum.with_index do
        now = DateTime.utc_now() |> DateTime.truncate(:second)
        {1, nil} = from(
                        post_image in PostImage,
                        where: post_image.id == ^post_image_id
                      )
        |> Repo.update_all(set: [order: i, updated_at: now])
      end
    end)
  end

  @doc """
  Update post's cover image
  """
  def update_post_cover_image(post_id, cover_image_id) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    update_status = from(
                    post in Post,
                    where: post.id == ^post_id
                  )
    |> Repo.update_all(set: [cover_image_id: cover_image_id, updated_at: now])
    case update_status do
      {1, nil} -> :ok
      _        -> :error
    end
  end

  @doc """
  Gets images not used by given post
  """
  def unused_images_for_post(post_id) do
    post_images_subquery = from(post_image in PostImage, where: post_image.post_id == ^post_id)

    from(
      i in Image,
      left_join: post_image in subquery(post_images_subquery),
      on: i.id == post_image.image_id,
      where: is_nil(post_image.image_id),
      order_by: [desc: i.id]
    )
    |> Repo.all
  end

  @doc """
  Gets images not used by any postpost
  """
  def unused_images() do
    from(
      i in Image,
      left_join: post_image in assoc(i, :post_images),
      on: i.id == post_image.image_id,
      where: is_nil(post_image.image_id),
      order_by: [desc: i.id]
    )
    |> Repo.all
  end



end
