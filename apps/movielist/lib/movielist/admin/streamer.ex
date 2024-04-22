defmodule Movielist.Admin.Streamer do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.movielist()
  schema "streamers" do
    field :name, :string

    has_many :movies, Movielist.Admin.Movie

    timestamps()
  end

  @doc false
  def changeset(streamer, attrs) do
    streamer
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
