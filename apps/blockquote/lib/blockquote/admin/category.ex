defmodule Blockquote.Admin.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.Category


  schema "categories" do
    field :name, :string

    timestamps()
    
    has_many :quotes, Blockquote.Admin.Quote
  end
  
  def required_fields() do
    [:name]
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required(required_fields())
    |> unique_constraint(:name)
  end
end
