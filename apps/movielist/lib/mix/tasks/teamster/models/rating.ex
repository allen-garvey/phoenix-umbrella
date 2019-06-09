defmodule Teamster.Models.LegacyRating do
  alias Movielist.Admin.Rating

  #no schema since rating is just contained in legacy movie

  @doc """
  Migrates legacy model to current movielist model
  """
  def migrate(legacy_movie) do
    current_time = NaiveDateTime.utc_now()
     |> NaiveDateTime.truncate(:second)
  	%Rating{
            inserted_at: current_time, 
            updated_at: current_time,
            
            movie_id: legacy_movie.id, 
            score: legacy_movie.post_rating, 
            date_scored: legacy_movie.date_watched, 
          }
  end
end