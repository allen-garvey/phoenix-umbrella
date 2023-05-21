defmodule Movielist.Admin.Movie do
  use Ecto.Schema
  import Ecto.Changeset


  schema "movies" do
    field :home_release_date, :date
    field :is_active, :boolean, default: true
    field :pre_rating, :integer, default: 80
    field :theater_release_date, :date
    field :title, :string
    field :sort_title, :string
    field :subtitle, :string
    field :length, :integer

    field :release_date, :date, virtual: true
    field :release_status, :any, virtual: true

    belongs_to :genre, Movielist.Admin.Genre
    belongs_to :streamer, Movielist.Admin.Streamer

    has_many :ratings, Movielist.Admin.Rating

    timestamps()
  end

  @doc """
  Adds sort_title to changeset generated from title
  """
  def generate_sort_title(changeset) do
    change(changeset, %{sort_title: sort_title_from(get_field(changeset, :title))})
  end

  def sort_title_from(nil) do
    nil
  end

  def sort_title_from(title) do
    Regex.replace(~r/^the\s+/i, title, "")
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :sort_title, :subtitle, :genre_id, :streamer_id, :theater_release_date, :home_release_date, :pre_rating, :is_active, :length])
    # sort_title is required, but we are not validating it here since it generated from the title
    |> validate_required([:title, :genre_id, :pre_rating, :is_active])
    |> generate_sort_title
    |> Common.ModelHelpers.Number.validate_score(:pre_rating)
    |> assoc_constraint(:genre)
    |> assoc_constraint(:streamer)
  end
end
