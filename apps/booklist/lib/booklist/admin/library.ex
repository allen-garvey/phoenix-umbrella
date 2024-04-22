defmodule Booklist.Admin.Library do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix Grenadier.RepoPrefix.booklist()
  schema "libraries" do
    field :name, :string
    field :super_search_key, :string
    field :url, :string

    has_many :locations, Booklist.Admin.Location

    timestamps()
  end

  @doc """
  Simple validation of url using regex
  """
  def validate_url(changeset, attribute_key) do
    url = get_field(changeset, attribute_key)
    if !is_nil(url) and !Regex.match?(~r/https?:\/\/.+\.\w+/, url) do
      add_error(changeset, attribute_key, "Not a valid url")
    else
      changeset
    end
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :url, :super_search_key])
    |> validate_required([:name])
    |> validate_url(:url)
    |> unique_constraint(:name)
  end
end
