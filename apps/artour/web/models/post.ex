defmodule Artour.Post do
  use Artour.Web, :model
  import Artour.ModelHelpers.SlugValidator, only: [validate_slug: 2]

  @schema_prefix Grenadier.RepoPrefix.artour()
  schema "posts" do
    field :title, :string
    field :slug, :string
    field :body, :string
    field :is_nsfw, :boolean, default: false
    field :is_markdown, :boolean, default: false
    field :is_published, :boolean, default: true
    field :publication_date, :date

    belongs_to :cover_image, Artour.Image

    has_many :post_images, Artour.PostImage

    many_to_many :images, Artour.Image, join_through: Artour.PostImage, on_delete: :delete_all
    many_to_many :tags, Artour.Tag, join_through: Artour.PostTag, on_delete: :delete_all
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :slug, :body, :cover_image_id, :is_nsfw, :is_markdown, :is_published, :publication_date])
    |> Common.ModelHelpers.Date.default_date_today(:publication_date)
    |> validate_required([:title, :slug, :cover_image_id, :is_nsfw, :is_markdown, :is_published, :publication_date])
    |> assoc_constraint(:cover_image)
    |> validate_slug(:slug)
    |> unique_constraint(:title)
    |> unique_constraint(:slug)
  end
end
