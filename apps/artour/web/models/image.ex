defmodule Artour.Image do
  use Artour.Web, :model
  import Artour.ModelHelpers.FilenameValidator, only: [validate_image_filename: 2]
  import Artour.ModelHelpers.SlugValidator, only: [validate_slug: 2]

  schema "images" do
    field :title, :string
    field :slug, :string
    field :description, :string
    field :filename_large, :string
    field :filename_medium, :string
    field :filename_small, :string
    field :filename_thumbnail, :string
    field :completion_date, :date

    belongs_to :format, Artour.Format

    has_many :post_images, Artour.PostImage

    many_to_many :posts, Artour.Post, join_through: "post_images", on_delete: :delete_all
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :slug, :description, :filename_large, :filename_medium, :filename_small, :filename_thumbnail, :completion_date, :format_id])
    |> validate_required([:title, :slug, :description, :filename_large, :filename_medium, :filename_small, :filename_thumbnail, :completion_date, :format_id])
    |> assoc_constraint(:format)
    |> unique_constraint(:title)
    |> unique_constraint(:slug)
    |> validate_slug(:slug)
    |> validate_image_filename(:filename_large)
    |> validate_image_filename(:filename_medium)
    |> validate_image_filename(:filename_small)
    |> validate_image_filename(:filename_thumbnail)
  end
end
