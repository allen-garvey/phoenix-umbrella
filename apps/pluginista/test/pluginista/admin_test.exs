defmodule Pluginista.AdminTest do
  use Pluginista.DataCase

  alias Pluginista.Admin

  describe "groups" do
    alias Pluginista.Admin.Group

    import Pluginista.AdminFixtures

    @invalid_attrs %{name: nil}

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Admin.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Admin.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Group{} = group} = Admin.create_group(valid_attrs)
      assert group.name == "some name"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Group{} = group} = Admin.update_group(group, update_attrs)
      assert group.name == "some updated name"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_group(group, @invalid_attrs)
      assert group == Admin.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Admin.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Admin.change_group(group)
    end
  end

  describe "makers" do
    alias Pluginista.Admin.Maker

    import Pluginista.AdminFixtures

    @invalid_attrs %{name: nil}

    test "list_makers/0 returns all makers" do
      maker = maker_fixture()
      assert Admin.list_makers() == [maker]
    end

    test "get_maker!/1 returns the maker with given id" do
      maker = maker_fixture()
      assert Admin.get_maker!(maker.id) == maker
    end

    test "create_maker/1 with valid data creates a maker" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Maker{} = maker} = Admin.create_maker(valid_attrs)
      assert maker.name == "some name"
    end

    test "create_maker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_maker(@invalid_attrs)
    end

    test "update_maker/2 with valid data updates the maker" do
      maker = maker_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Maker{} = maker} = Admin.update_maker(maker, update_attrs)
      assert maker.name == "some updated name"
    end

    test "update_maker/2 with invalid data returns error changeset" do
      maker = maker_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_maker(maker, @invalid_attrs)
      assert maker == Admin.get_maker!(maker.id)
    end

    test "delete_maker/1 deletes the maker" do
      maker = maker_fixture()
      assert {:ok, %Maker{}} = Admin.delete_maker(maker)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_maker!(maker.id) end
    end

    test "change_maker/1 returns a maker changeset" do
      maker = maker_fixture()
      assert %Ecto.Changeset{} = Admin.change_maker(maker)
    end
  end

  describe "categories" do
    alias Pluginista.Admin.Category

    import Pluginista.AdminFixtures

    @invalid_attrs %{name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Admin.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Admin.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Category{} = category} = Admin.create_category(valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Category{} = category} = Admin.update_category(category, update_attrs)
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
end
