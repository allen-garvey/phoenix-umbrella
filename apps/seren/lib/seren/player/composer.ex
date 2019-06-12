defmodule Seren.Player.Composer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Seren.Player.Composer


  schema "composers" do
    field :name, :string

    timestamps()

    has_many :tracks, Seren.Player.Track
  end

  @doc false
  def changeset(%Composer{} = composer, attrs) do
    composer
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
