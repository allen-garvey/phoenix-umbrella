defmodule Blockquote.Admin.SourceType do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.SourceType

  @schema_prefix Grenadier.RepoPrefix.blockquote()
  schema "source_types" do
    field :name, :string

    timestamps()
    
    has_many :parent_sources, Blockquote.Admin.ParentSource
    has_many :sources, Blockquote.Admin.Source
  end

  @doc false
  def changeset(%SourceType{} = source_type, attrs) do
    source_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
