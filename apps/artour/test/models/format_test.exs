defmodule Artour.FormatTest do
  use Artour.ModelCase

  alias Artour.Format

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Format.changeset(%Format{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Format.changeset(%Format{}, @invalid_attrs)
    refute changeset.valid?
  end
end
