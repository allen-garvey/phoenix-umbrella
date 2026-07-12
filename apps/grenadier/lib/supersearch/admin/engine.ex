defmodule Supersearch.Admin.Engine do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.supersearch()
  schema "engines" do
    field :name, :string
    field :url, :string
    field :order, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(engine, attrs) do
    engine
    |> cast(attrs, [:name, :url, :order])
    |> validate_required([:name, :url, :order])
  end
end
