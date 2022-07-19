defmodule Photog.Repo.Migrations.PopulateAlbumYearFromCoverImage do
  use Ecto.Migration
  import Ecto.Query, warn: false
  
  alias Photog.Repo
  alias Photog.Api.Album

  def up do
    from(
      album in Album,
      join: cover_image in assoc(album, :cover_image),
      select: {album.id, cover_image.creation_time}
    )
    |> Repo.all
    |> Enum.map(fn {album_id, image_creation_time} -> 
      from(
        album in Album,
        where: album.id == ^album_id
      )
      |> Repo.update_all(set: [year: image_creation_time.year])
    end)
  end

  def down do
    nil
  end
end
