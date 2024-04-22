defmodule Artour.PostTag do
  use Artour.Web, :model

  @schema_prefix Grenadier.RepoPrefix.artour()
  schema "post_tags" do
    belongs_to :post, Artour.Post
    belongs_to :tag, Artour.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:tag)
    |> unique_constraint(:post_tag_unique_composite, name: :post_tag_unique_composite)
  end
end
