defmodule Photog.Shutterbug do
  @moduledoc """
  The Shutterbug context.
  """

  import Ecto.Query, warn: false
  alias Photog.Repo

  alias Photog.Api.Image

  @doc """
  Gets count of number of images with the amazon_photos_id field filled out
  """
  def get_count_of_images_with_amazon_photos_id do
    from(i in Image, select: count("*"), where: not is_nil(i.amazon_photos_id))
    |> Repo.one!
  end

  @doc """
  Adds the amazon_photos_id field to an image
  the amazon photos API doesn't give the full path for the image, so we are going to use
  the master file name and creation year and month to narrow down which image it is
  """
  def add_amazon_photos_id(amazon_photos_id, master_file_name)
    when is_binary(amazon_photos_id) and is_binary(master_file_name) do
      file_name_regex = "/#{master_file_name}$"
      add_amazon_photos_id_helper(amazon_photos_id, file_name_regex)
  end

  @doc """
  First try adding amazon photos id based on filename, and rollback if more than 1 image matched
  """
  def add_amazon_photos_id_helper(amazon_photos_id, file_name_regex) do
    now = DateTime.utc_now()

    try do
      Repo.transaction(fn ->
        case from(
          i in Image,
          where: fragment("? ~ ?", i.master_path, ^file_name_regex) and is_nil(i.amazon_photos_id)
        )
        |> Repo.update_all(set: [
          amazon_photos_id: amazon_photos_id,
          updated_at: now,
        ]) do
          {0, _} -> {:ok, nil}
          {1, _} -> {:ok, nil}
          {_, _} -> Repo.rollback(:too_many_updates)
        end
      end)
    rescue
      _ -> {:error, nil}
    end
  end
end
