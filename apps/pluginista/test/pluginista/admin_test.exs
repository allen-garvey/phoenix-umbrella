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

  describe "plugins" do
    alias Pluginista.Admin.Plugin

    import Pluginista.AdminFixtures

    @invalid_attrs %{acquisition_date: nil, cost: nil, name: nil}

    test "list_plugins/0 returns all plugins" do
      plugin = plugin_fixture()
      assert Admin.list_plugins() == [plugin]
    end

    test "get_plugin!/1 returns the plugin with given id" do
      plugin = plugin_fixture()
      assert Admin.get_plugin!(plugin.id) == plugin
    end

    test "create_plugin/1 with valid data creates a plugin" do
      valid_attrs = %{acquisition_date: ~D[2022-10-12], cost: "120.5", name: "some name"}

      assert {:ok, %Plugin{} = plugin} = Admin.create_plugin(valid_attrs)
      assert plugin.acquisition_date == ~D[2022-10-12]
      assert plugin.cost == Decimal.new("120.5")
      assert plugin.name == "some name"
    end

    test "create_plugin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_plugin(@invalid_attrs)
    end

    test "update_plugin/2 with valid data updates the plugin" do
      plugin = plugin_fixture()
      update_attrs = %{acquisition_date: ~D[2022-10-13], cost: "456.7", name: "some updated name"}

      assert {:ok, %Plugin{} = plugin} = Admin.update_plugin(plugin, update_attrs)
      assert plugin.acquisition_date == ~D[2022-10-13]
      assert plugin.cost == Decimal.new("456.7")
      assert plugin.name == "some updated name"
    end

    test "update_plugin/2 with invalid data returns error changeset" do
      plugin = plugin_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_plugin(plugin, @invalid_attrs)
      assert plugin == Admin.get_plugin!(plugin.id)
    end

    test "delete_plugin/1 deletes the plugin" do
      plugin = plugin_fixture()
      assert {:ok, %Plugin{}} = Admin.delete_plugin(plugin)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_plugin!(plugin.id) end
    end

    test "change_plugin/1 returns a plugin changeset" do
      plugin = plugin_fixture()
      assert %Ecto.Changeset{} = Admin.change_plugin(plugin)
    end
  end

  describe "plugin_categories" do
    alias Pluginista.Admin.PluginCategory

    import Pluginista.AdminFixtures

    @invalid_attrs %{}

    test "list_plugin_categories/0 returns all plugin_categories" do
      plugin_category = plugin_category_fixture()
      assert Admin.list_plugin_categories() == [plugin_category]
    end

    test "get_plugin_category!/1 returns the plugin_category with given id" do
      plugin_category = plugin_category_fixture()
      assert Admin.get_plugin_category!(plugin_category.id) == plugin_category
    end

    test "create_plugin_category/1 with valid data creates a plugin_category" do
      valid_attrs = %{}

      assert {:ok, %PluginCategory{} = plugin_category} = Admin.create_plugin_category(valid_attrs)
    end

    test "create_plugin_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_plugin_category(@invalid_attrs)
    end

    test "update_plugin_category/2 with valid data updates the plugin_category" do
      plugin_category = plugin_category_fixture()
      update_attrs = %{}

      assert {:ok, %PluginCategory{} = plugin_category} = Admin.update_plugin_category(plugin_category, update_attrs)
    end

    test "update_plugin_category/2 with invalid data returns error changeset" do
      plugin_category = plugin_category_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_plugin_category(plugin_category, @invalid_attrs)
      assert plugin_category == Admin.get_plugin_category!(plugin_category.id)
    end

    test "delete_plugin_category/1 deletes the plugin_category" do
      plugin_category = plugin_category_fixture()
      assert {:ok, %PluginCategory{}} = Admin.delete_plugin_category(plugin_category)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_plugin_category!(plugin_category.id) end
    end

    test "change_plugin_category/1 returns a plugin_category changeset" do
      plugin_category = plugin_category_fixture()
      assert %Ecto.Changeset{} = Admin.change_plugin_category(plugin_category)
    end
  end
end
