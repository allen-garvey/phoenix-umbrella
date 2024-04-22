defmodule Artour.PostImage do
  use Artour.Web, :model

  @schema_prefix Grenadier.RepoPrefix.artour()
  schema "post_images" do
    field :order, :integer
    field :caption, :string
    belongs_to :post, Artour.Post
    belongs_to :image, Artour.Image

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:order, :caption, :post_id, :image_id])
    |> validate_required([:post_id, :image_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:image)
    |> unique_constraint(:post_image_unique_composite, name: :post_image_unique_composite)
  end
end
