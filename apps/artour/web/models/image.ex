defmodule Artour.Image do
  use Artour.Web, :model
  import Artour.ModelHelpers.FilenameValidator, only: [validate_image_filename: 2]

  @schema_prefix Grenadier.RepoPrefix.artour()
  schema "images" do
    field :title, :string
    field :description, :string
    field :filename_large, :string
    field :filename_medium, :string
    field :filename_small, :string
    field :filename_thumbnail, :string
    field :completion_date, :date
    field :year, :integer

    has_many :post_images, Artour.PostImage

    many_to_many :posts, Artour.Post, join_through: Artour.PostImage, on_delete: :delete_all
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :filename_large, :filename_medium, :filename_small, :filename_thumbnail, :completion_date, :year])
    |> validate_required([:title, :description, :filename_large, :filename_medium, :filename_small, :filename_thumbnail, :year])
    |> unique_constraint(:title)
    |> validate_image_filename(:filename_large)
    |> validate_image_filename(:filename_medium)
    |> validate_image_filename(:filename_small)
    |> validate_image_filename(:filename_thumbnail)
  end
end
