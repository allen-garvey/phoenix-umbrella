defmodule Artour.Repo.Migrations.PrefillImageYearFromCompletionDate do
  use Ecto.Migration

  import Ecto.Query, warn: false
  
  alias Artour.Repo
  alias Artour.Image

  def change do
    from(
      image in Image,
      select: {image.id, image.completion_date}
    )
    |> Repo.all
    |> Enum.map(fn {image_id, completion_date} -> 
      from(
        image in Image,
        where: image.id == ^image_id
      )
      |> Repo.update_all(set: [year: completion_date.year])
    end)
  end
end
