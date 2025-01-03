defmodule Blockquote.Admin.ParentSource do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.ParentSource

  @schema_prefix Grenadier.RepoPrefix.blockquote()
  schema "parent_sources" do
    field :subtitle, :string
    field :title, :string
    field :sort_title, :string
    field :url, :string

    timestamps()

    has_many :sources, Blockquote.Admin.Source
    belongs_to :source_type, Blockquote.Admin.SourceType
  end

  @doc false
  def changeset(%ParentSource{} = parent_source, attrs) do
    parent_source
    |> cast(attrs, [:title, :subtitle, :url, :source_type_id, :sort_title])
    |> Common.ModelHelpers.SortTitle.generate_sort_title(:title, :sort_title)
    |> validate_required([:title, :sort_title, :source_type_id])
    |> assoc_constraint(:source_type)
  end
end
