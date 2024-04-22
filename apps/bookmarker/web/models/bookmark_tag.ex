defmodule Bookmarker.BookmarkTag do
  use Bookmarker.Web, :model

  @schema_prefix Grenadier.RepoPrefix.bookmarker()
  schema "bookmarks_tags" do
    belongs_to :bookmark, Bookmarker.Bookmark
    belongs_to :tag, Bookmarker.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:bookmark_id, :tag_id])
    |> validate_required([:bookmark_id, :tag_id])
    |> assoc_constraint(:bookmark)
    |> assoc_constraint(:tag)
    |> unique_constraint(:bookmark_tag_composite, name: :bookmark_tag_composite)
  end
end
