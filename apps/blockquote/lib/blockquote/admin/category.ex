defmodule Blockquote.Admin.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.Category

  @schema_prefix Grenadier.RepoPrefix.blockquote()
  schema "categories" do
    field :name, :string

    timestamps()
    
    has_many :quotes, Blockquote.Admin.Quote
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
