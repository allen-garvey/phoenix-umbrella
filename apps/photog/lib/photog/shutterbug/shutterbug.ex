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
  def add_amazon_photos_id(amazon_photos_id, master_file_name, creation_year, creation_month, creation_day)
    when is_binary(amazon_photos_id) and is_binary(master_file_name) and is_integer(creation_year) and is_integer(creation_month) do
      file_name_regex = "/#{master_file_name}$"
      now = DateTime.utc_now()

      from(
            i in Image,
            where: fragment("? ~ ?", i.master_path, ^file_name_regex) and is_nil(i.amazon_photos_id) and fragment("EXTRACT(year FROM ?)", i.creation_time) == ^creation_year and fragment("EXTRACT(month FROM ?)", i.creation_time) == ^creation_month and fragment("EXTRACT(day FROM ?)", i.creation_time) == ^creation_day
      )
      |> Repo.update_all(set: [
                                amazon_photos_id: amazon_photos_id,
                                updated_at: now,
                              ])
  end
end
