defmodule Blockquote.Admin.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.Author


  schema "authors" do
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string

    timestamps()
    
    has_many :quotes, Blockquote.Admin.Quote
    has_many :sources, Blockquote.Admin.Source
  end
  
  def required_fields() do
    [:first_name]
  end
  
  @doc """
	Validate that middle name must be null if last name is null
	"""
	def validate_middle_name(changeset) do
	  middle_name_key = :middle_name
		middle_name = get_field(changeset, middle_name_key)
    last_name = get_field(changeset, :last_name)
    
    if !is_nil(middle_name) and is_nil(last_name) do
      add_error(changeset, middle_name_key, "Middle name must be blank if last name is blank")
    else
      changeset
    end
		
	end

  @doc false
  def changeset(%Author{} = author, attrs) do
    author
    |> cast(attrs, [:first_name, :middle_name, :last_name])
    |> validate_required(required_fields())
    |> unique_constraint(:first_name, name: :author_unique_name_index)
    |> unique_constraint(:middle_name, name: :author_unique_name_index)
    |> unique_constraint(:last_name, name: :author_unique_name_index)
    |> validate_middle_name
  end
end
