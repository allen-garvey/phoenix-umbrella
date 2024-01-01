defmodule Pluginista.Admin.Maker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "makers" do
    field :name, :string

    has_many :plugins, Pluginista.Admin.Plugin

    timestamps()
  end

  @doc false
  def changeset(maker, attrs) do
    maker
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
