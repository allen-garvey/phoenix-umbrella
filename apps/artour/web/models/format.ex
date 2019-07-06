defmodule Artour.Format do
  use Artour.Web, :model

  schema "formats" do
    field :name, :string

    has_many :images, Artour.Image
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @doc """
  Maps a list of formats into tuples, used for forms
  """
  def map_for_form(formats) do
    Enum.map(formats, &{&1.name, &1.id})
  end

  @doc """
  Returns list of formats with name and id
  ordered in default order suitable for select fields
  for forms
  """
  def form_list(repo) do
    repo.all(from(Artour.Format, order_by: [desc: :name])) |> map_for_form
  end

end
