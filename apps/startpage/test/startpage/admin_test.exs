defmodule Startpage.AdminTest do
  use Startpage.DataCase

  alias Startpage.Admin

  describe "folders" do
    alias Startpage.Admin.Folder

    @valid_attrs %{content: "some content", name: "some name", order: 42, theme: "some theme"}
    @update_attrs %{content: "some updated content", name: "some updated name", order: 43, theme: "some updated theme"}
    @invalid_attrs %{content: nil, name: nil, order: nil, theme: nil}

    def folder_fixture(attrs \\ %{}) do
      {:ok, folder} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_folder()

      folder
    end

    test "list_folders/0 returns all folders" do
      folder = folder_fixture()
      assert Admin.list_folders() == [folder]
    end

    test "get_folder!/1 returns the folder with given id" do
      folder = folder_fixture()
      assert Admin.get_folder!(folder.id) == folder
    end

    test "create_folder/1 with valid data creates a folder" do
      assert {:ok, %Folder{} = folder} = Admin.create_folder(@valid_attrs)
      assert folder.content == "some content"
      assert folder.name == "some name"
      assert folder.order == 42
      assert folder.theme == "some theme"
    end

    test "create_folder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_folder(@invalid_attrs)
    end

    test "update_folder/2 with valid data updates the folder" do
      folder = folder_fixture()
      assert {:ok, %Folder{} = folder} = Admin.update_folder(folder, @update_attrs)
      assert folder.content == "some updated content"
      assert folder.name == "some updated name"
      assert folder.order == 43
      assert folder.theme == "some updated theme"
    end

    test "update_folder/2 with invalid data returns error changeset" do
      folder = folder_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_folder(folder, @invalid_attrs)
      assert folder == Admin.get_folder!(folder.id)
    end

    test "delete_folder/1 deletes the folder" do
      folder = folder_fixture()
      assert {:ok, %Folder{}} = Admin.delete_folder(folder)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_folder!(folder.id) end
    end

    test "change_folder/1 returns a folder changeset" do
      folder = folder_fixture()
      assert %Ecto.Changeset{} = Admin.change_folder(folder)
    end
  end
end
