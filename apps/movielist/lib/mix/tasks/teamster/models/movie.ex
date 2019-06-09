defmodule Teamster.Models.LegacyMovie do
  use Ecto.Schema

  alias Movielist.Admin.Movie


  schema "movies" do
    field :title, :string
    field :theater_release, :date
    field :dvd_release, :date
    field :date_watched, :date
    field :pre_rating, :integer
    field :post_rating, :integer
    field :genre_id, :id
    field :active, :boolean
  end

  @doc """
  Migrates legacy model to current movielist model
  """
  def migrate(legacy_movie) do
    current_time = NaiveDateTime.utc_now()
     |> NaiveDateTime.truncate(:second)
  	%Movie{
            id: legacy_movie.id,
            inserted_at: current_time, 
            updated_at: current_time,
            
            title: legacy_movie.title,
            sort_title: Movie.sort_title_from(legacy_movie.title),
            genre_id: legacy_movie.genre_id,
            is_active: legacy_movie.active and is_nil(legacy_movie.post_rating),
            theater_release_date: legacy_movie.theater_release,
            home_release_date: legacy_movie.dvd_release,
            pre_rating: legacy_movie.pre_rating,
          }
  end
end