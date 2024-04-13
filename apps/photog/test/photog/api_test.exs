defmodule Photog.ApiTest do
  use Photog.DataCase

  alias Photog.Api

  describe "year_images" do
    alias Photog.Api.YearImage

    import Photog.ApiFixtures

    @invalid_attrs %{year: nil}

    test "list_year_images/0 returns all year_images" do
      year_image = year_image_fixture()
      assert Api.list_year_images() == [year_image]
    end

    test "get_year_image!/1 returns the year_image with given id" do
      year_image = year_image_fixture()
      assert Api.get_year_image!(year_image.id) == year_image
    end

    test "create_year_image/1 with valid data creates a year_image" do
      valid_attrs = %{year: 42}

      assert {:ok, %YearImage{} = year_image} = Api.create_year_image(valid_attrs)
      assert year_image.year == 42
    end

    test "create_year_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_year_image(@invalid_attrs)
    end

    test "update_year_image/2 with valid data updates the year_image" do
      year_image = year_image_fixture()
      update_attrs = %{year: 43}

      assert {:ok, %YearImage{} = year_image} = Api.update_year_image(year_image, update_attrs)
      assert year_image.year == 43
    end

    test "update_year_image/2 with invalid data returns error changeset" do
      year_image = year_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_year_image(year_image, @invalid_attrs)
      assert year_image == Api.get_year_image!(year_image.id)
    end

    test "delete_year_image/1 deletes the year_image" do
      year_image = year_image_fixture()
      assert {:ok, %YearImage{}} = Api.delete_year_image(year_image)
      assert_raise Ecto.NoResultsError, fn -> Api.get_year_image!(year_image.id) end
    end

    test "change_year_image/1 returns a year_image changeset" do
      year_image = year_image_fixture()
      assert %Ecto.Changeset{} = Api.change_year_image(year_image)
    end
  end
end
