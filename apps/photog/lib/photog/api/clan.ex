defmodule Photog.Api.Clan do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.photog()
  schema "clans" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(clan, attrs) do
    clan
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
