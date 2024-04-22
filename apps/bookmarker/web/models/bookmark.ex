defmodule Bookmarker.Bookmark do
  use Bookmarker.Web, :model

  @schema_prefix Grenadier.RepoPrefix.bookmarker()
  schema "bookmarks" do
    field :title, :string
    field :url, :string
    field :description, :string
    field :rss_url, :string
    field :preview_image_selector, :string
    field :thumbnail_url, :string
    belongs_to :folder, Bookmarker.Folder
    many_to_many :tags, Bookmarker.Tag, join_through: Bookmarker.BookmarkTag, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :url, :description, :folder_id, :rss_url, :preview_image_selector, :thumbnail_url])
    |> validate_required([:title, :url, :folder_id])
    |> assoc_constraint(:folder)
  end

  @doc """
  Returns string representation of model
  """
  def to_s(bookmark) do
    bookmark.title
  end 

  @doc """
  Returns all bookmarks in Repo in sorted order
  """
  def all_in_order_query() do
    from(b in Bookmarker.Bookmark, order_by: b.title)
  end 

  @doc """
  Returns list of bookmarks with title and id
  ordered in default order suitable for select fields
  for forms
  """
  def form_list(repo) do
    repo.all(all_in_order_query()) |> Enum.map(&{&1.title, &1.id})
  end
end
