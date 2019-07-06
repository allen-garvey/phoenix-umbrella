defmodule Artour.PostImageTest do
  use Artour.ModelCase

  alias Artour.PostImage

  @valid_attrs %{caption: "some content", order: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostImage.changeset(%PostImage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostImage.changeset(%PostImage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
