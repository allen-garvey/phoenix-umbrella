defmodule Blockquote.Admin.ParentSource do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.ParentSource
  alias Blockquote.Admin.ModelHelpers.SortTitle


  schema "parent_sources" do
    field :subtitle, :string
    field :title, :string
    field :sort_title, :string
    field :url, :string
    
    timestamps()
    
    has_many :sources, Blockquote.Admin.Source
    belongs_to :source_type, Blockquote.Admin.SourceType
  end
  
  def required_fields() do
    [:title, :sort_title, :source_type_id]
  end

  @doc false
  def changeset(%ParentSource{} = parent_source, attrs) do
    parent_source
    |> cast(attrs, [:title, :subtitle, :url, :source_type_id, :sort_title])
    |> SortTitle.generate_sort_title(:title, :sort_title)
    |> validate_required(required_fields())
    |> assoc_constraint(:source_type)
  end
end
