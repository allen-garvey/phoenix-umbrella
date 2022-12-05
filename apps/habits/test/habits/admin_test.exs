defmodule Habits.AdminTest do
  use Habits.DataCase

  alias Habits.Admin

  describe "categories" do
    alias Habits.Admin.Category

    import Habits.AdminFixtures

    @invalid_attrs %{color: nil, name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Admin.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Admin.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{color: "some color", name: "some name"}

      assert {:ok, %Category{} = category} = Admin.create_category(valid_attrs)
      assert category.color == "some color"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{color: "some updated color", name: "some updated name"}

      assert {:ok, %Category{} = category} = Admin.update_category(category, update_attrs)
      assert category.color == "some updated color"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_category(category, @invalid_attrs)
      assert category == Admin.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Admin.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Admin.change_category(category)
    end
  end

  describe "activities" do
    alias Habits.Admin.Activity

    import Habits.AdminFixtures

    @invalid_attrs %{date: nil, description: nil, title: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Admin.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Admin.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = %{date: ~D[2022-12-04], description: "some description", title: "some title"}

      assert {:ok, %Activity{} = activity} = Admin.create_activity(valid_attrs)
      assert activity.date == ~D[2022-12-04]
      assert activity.description == "some description"
      assert activity.title == "some title"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{date: ~D[2022-12-05], description: "some updated description", title: "some updated title"}

      assert {:ok, %Activity{} = activity} = Admin.update_activity(activity, update_attrs)
      assert activity.date == ~D[2022-12-05]
      assert activity.description == "some updated description"
      assert activity.title == "some updated title"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_activity(activity, @invalid_attrs)
      assert activity == Admin.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Admin.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Admin.change_activity(activity)
    end
  end
end
