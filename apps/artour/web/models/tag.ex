defmodule Artour.Tag do
  use Artour.Web, :model
  import Artour.ModelHelpers.SlugValidator, only: [validate_slug: 2]

  @schema_prefix Grenadier.RepoPrefix.artour()
  schema "tags" do
    field :name, :string
    field :slug, :string

    many_to_many :posts, Artour.Post, join_through: Artour.PostTag, on_delete: :delete_all
    has_many :post_tags, Artour.PostTag
    timestamps()
  end

  Common.ViewHelpers.Form.define_map_for_form(true)

  @doc """
  Query used for default order
  """
  def default_order_query() do
    from(Artour.Tag, order_by: :name)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :slug])
    |> validate_required([:name, :slug])
    |> validate_slug(:slug)
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end

  @doc """
  Returns list of tags with name and id
  ordered in default order suitable for select fields
  for forms
  """
  def form_list(repo) do
    repo.all(default_order_query()) |> map_for_form
  end
end
