defmodule Blockquote.Admin.Source do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.Source

  @schema_prefix Grenadier.RepoPrefix.blockquote()
  schema "sources" do
    field :subtitle, :string
    field :title, :string
    field :sort_title, :string
    field :url, :string
    field :release_date, :date

    timestamps()

    has_many :quotes, Blockquote.Admin.Quote
    belongs_to :source_type, Blockquote.Admin.SourceType
    belongs_to :author, Blockquote.Admin.Author
    belongs_to :parent_source, Blockquote.Admin.ParentSource
  end

  @doc false
  def changeset(%Source{} = source, attrs) do
    source
    |> cast(attrs, [:title, :subtitle, :url, :author_id, :source_type_id, :parent_source_id, :sort_title, :release_date])
    |> Common.ModelHelpers.SortTitle.generate_sort_title(:title, :sort_title)
    |> validate_required([:title, :sort_title, :author_id, :source_type_id])
    |> assoc_constraint(:source_type)
    |> assoc_constraint(:author)
    |> assoc_constraint(:parent_source)
  end
end
