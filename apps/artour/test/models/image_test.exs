defmodule Artour.ImageTest do
  use Artour.ModelCase

  alias Artour.Image

  @valid_attrs %{completion_date: %{day: 17, month: 4, year: 2010}, description: "some content", filename_large: "some content", filename_medium: "some content", filename_small: "some content", filename_thumbnail: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Image.changeset(%Image{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Image.changeset(%Image{}, @invalid_attrs)
    refute changeset.valid?
  end
end
