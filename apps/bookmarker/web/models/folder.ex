defmodule Bookmarker.Folder do
  use Bookmarker.Web, :model

  @schema_prefix Grenadier.RepoPrefix.bookmarker()
  schema "folders" do
    field :name, :string
    field :description, :string
    field :is_favorite, :boolean, default: false
    has_many :bookmarks, Bookmarker.Bookmark

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :is_favorite])
    |> validate_required([:name, :is_favorite])
    |> unique_constraint(:name)
  end

  @doc """
  Returns string representation of model
  """
  def to_s(folder) do
    folder.name
  end

  @doc """
  Returns all folders in Repo in sorted order
  """
  def all_in_order_query() do
    from(f in Bookmarker.Folder, order_by: f.name)
  end

  @doc """
  Returns list of maps (folders) and their
  count of bookmarks
  """
  def with_bookmarks_count_query() do
    from(f in Bookmarker.Folder,
          left_join: b in Bookmarker.Bookmark, on: f.id == b.folder_id,
          group_by: [f.id, f.name, f.description],
          select: %{name: f.name, id: f.id, description: f.description, bookmark_count: count(b.folder_id)},
          order_by: f.name)
  end

end
