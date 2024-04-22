defmodule Bookmarker.Tag do
  use Bookmarker.Web, :model

  @schema_prefix Grenadier.RepoPrefix.bookmarker()
  schema "tags" do
    field :name, :string
    many_to_many :bookmarks, Bookmarker.Bookmark, join_through: Bookmarker.BookmarkTag, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @doc """
  Returns all tags in Repo in sorted order
  """
  def all_in_order_query() do
    from(t in Bookmarker.Tag, order_by: t.name)
  end 

  @doc """
  Returns list of tags with name and id
  ordered in default order suitable for select fields
  for forms
  """
  def form_list(repo) do
    repo.all(all_in_order_query()) |> Enum.map(&{&1.name, &1.id})
  end
end
