defmodule Startpage.Admin.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "folders" do
    field :content, :string
    field :name, :string
    field :order, :integer
    field :theme, :string

    timestamps()
  end

  @doc false
  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:name, :theme, :order, :content])
    |> validate_required([:name, :theme, :order, :content])
  end
end
