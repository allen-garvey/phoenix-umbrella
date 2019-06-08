defmodule Blockquote.Admin.Quote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blockquote.Admin.Quote


  schema "quotes" do
    field :body, :string

    timestamps()
    
    belongs_to :category, Blockquote.Admin.Category
    belongs_to :author, Blockquote.Admin.Author
    belongs_to :source, Blockquote.Admin.Source
    
    has_many :daily_quotes, Blockquote.Admin.DailyQuote
  end
  
  def required_fields() do
    [:body, :source_id, :category_id]
  end
  
  @doc """
	Validates that the quote author_id is blank or not the same
	as the source author id
	"""
	def validate_author_id(changeset, %Blockquote.Admin.Source{} = source) do
	  author_key_name = :author_id
		author_id = get_field(changeset, author_key_name)
    
    if !is_nil(author_id) and author_id == source.author_id do
      add_error(changeset, author_key_name, "Author must be blank or different from source author")
    else
      changeset
    end
	end

  @doc false
  def changeset(%Quote{} = quote, attrs) do
    quote
    |> cast(attrs, [:body, :author_id, :category_id, :source_id])
    |> validate_required(required_fields())
    |> assoc_constraint(:author)
    |> assoc_constraint(:source)
    |> assoc_constraint(:category)
  end
end
