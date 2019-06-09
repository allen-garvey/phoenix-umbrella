defmodule Teamster.Models.LegacyGenre do
  use Ecto.Schema

  alias Movielist.Admin.Genre

  @primary_key {:genre_id, :integer, []}
  schema "m_genre" do
    field :title, :string
  end

  @doc """
  Migrates legacy model to current movielist model
  """
  def migrate(legacy_genre) do
    current_time = NaiveDateTime.utc_now()
     |> NaiveDateTime.truncate(:second)
  	%Genre{id: legacy_genre.genre_id, name: legacy_genre.title, inserted_at: current_time, updated_at: current_time}
  end
end