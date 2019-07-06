defmodule Artour.Post do
  use Artour.Web, :model
  import Artour.ModelHelpers.SlugValidator, only: [validate_slug: 2]

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :body, :string
    field :is_nsfw, :boolean, default: false
    field :is_markdown, :boolean, default: false
    field :is_published, :boolean, default: true
    field :publication_date, :date

    belongs_to :category, Artour.Category
    belongs_to :cover_image, Artour.Image

    has_many :post_images, Artour.PostImage

    many_to_many :images, Artour.Image, join_through: "post_images", on_delete: :delete_all
    many_to_many :tags, Artour.Tag, join_through: "post_tags", on_delete: :delete_all
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :slug, :body, :category_id, :cover_image_id, :is_nsfw, :is_markdown, :is_published, :publication_date])
    |> Artour.ModelHelpers.Date.default_date_today(:publication_date)
    |> validate_required([:title, :slug, :category_id, :cover_image_id, :is_nsfw, :is_markdown, :is_published, :publication_date])
    |> assoc_constraint(:category)
    |> assoc_constraint(:cover_image)
    |> validate_slug(:slug)
    |> unique_constraint(:title)
    |> unique_constraint(:slug)
  end
end
