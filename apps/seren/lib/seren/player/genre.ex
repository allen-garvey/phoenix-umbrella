defmodule Seren.Player.Genre do
  use Ecto.Schema
  import Ecto.Changeset
  alias Seren.Player.Genre


  schema "genres" do
    field :name, :string

    timestamps()

    has_many :tracks, Seren.Player.Track
  end

  @doc false
  def changeset(%Genre{} = genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
