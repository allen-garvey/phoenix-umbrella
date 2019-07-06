defmodule Artour.CategoryTest do
  use Artour.ModelCase

  alias Artour.Category

  @valid_attrs %{name: "some content", slug: "some content", type: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
