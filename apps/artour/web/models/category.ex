defmodule Artour.Category do
  use Artour.Web, :model
  import Artour.ModelHelpers.SlugValidator, only: [validate_slug: 2]

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :type, :integer

    has_many :posts, Artour.Post

    timestamps()
  end

  @doc """
  Query used for default order
  """
  def default_order_query() do
    from(Artour.Category, order_by: :name)
  end

  @doc """
  category type acts as an enum, so check it is valid
  before saving
  """
  def validate_category_type(changeset, type_key) do
    type_value = get_field(changeset, type_key)
    if !Artour.CategoryType.is_valid(type_value) do
      add_error(changeset, type_key, "Invalid category type")
    else
      changeset
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :slug, :type])
    |> validate_required([:name, :slug, :type])
    |> validate_category_type(:type)
    |> validate_slug(:slug)
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end

  Common.ViewHelpers.Form.define_map_for_form_default()

  @doc """
  Returns list of categories with name and id
  ordered in default order suitable for select fields
  for forms
  """
  def form_list(repo) do
    repo.all(default_order_query()) |> map_for_form
  end
end
