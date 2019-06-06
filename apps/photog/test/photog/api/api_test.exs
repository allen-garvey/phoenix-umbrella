defmodule Photog.ApiTest do
  use Photog.DataCase

  alias Photog.Api

  describe "images" do
    alias Photog.Api.Image

    @valid_attrs %{apple_photos_id: 42, creation_time: "2010-04-17 14:00:00.000000Z", is_favorite: true, master_path: "some master_path", mini_thumbnail_path: "some mini_thumbnail_path", thumbnail_path: "some thumbnail_path"}
    @update_attrs %{apple_photos_id: 43, creation_time: "2011-05-18 15:01:01.000000Z", is_favorite: false, master_path: "some updated master_path", mini_thumbnail_path: "some updated mini_thumbnail_path", thumbnail_path: "some updated thumbnail_path"}
    @invalid_attrs %{apple_photos_id: nil, creation_time: nil, is_favorite: nil, master_path: nil, mini_thumbnail_path: nil, thumbnail_path: nil}

    def image_fixture(attrs \\ %{}) do
      {:ok, image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_image()

      image
    end

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Api.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Api.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      assert {:ok, %Image{} = image} = Api.create_image(@valid_attrs)
      assert image.apple_photos_id == 42
      assert image.creation_time == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert image.is_favorite == true
      assert image.master_path == "some master_path"
      assert image.mini_thumbnail_path == "some mini_thumbnail_path"
      assert image.thumbnail_path == "some thumbnail_path"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      assert {:ok, image} = Api.update_image(image, @update_attrs)
      assert %Image{} = image
      assert image.apple_photos_id == 43
      assert image.creation_time == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert image.is_favorite == false
      assert image.master_path == "some updated master_path"
      assert image.mini_thumbnail_path == "some updated mini_thumbnail_path"
      assert image.thumbnail_path == "some updated thumbnail_path"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_image(image, @invalid_attrs)
      assert image == Api.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Api.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Api.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Api.change_image(image)
    end
  end

  describe "albums" do
    alias Photog.Api.Album

    @valid_attrs %{apple_photos_id: 42, folder_order: 42, name: "some name"}
    @update_attrs %{apple_photos_id: 43, folder_order: 43, name: "some updated name"}
    @invalid_attrs %{apple_photos_id: nil, folder_order: nil, name: nil}

    def album_fixture(attrs \\ %{}) do
      {:ok, album} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_album()

      album
    end

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Api.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Api.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      assert {:ok, %Album{} = album} = Api.create_album(@valid_attrs)
      assert album.apple_photos_id == 42
      assert album.folder_order == 42
      assert album.name == "some name"
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      assert {:ok, album} = Api.update_album(album, @update_attrs)
      assert %Album{} = album
      assert album.apple_photos_id == 43
      assert album.folder_order == 43
      assert album.name == "some updated name"
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_album(album, @invalid_attrs)
      assert album == Api.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Api.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Api.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Api.change_album(album)
    end
  end

  describe "persons" do
    alias Photog.Api.Person

    @valid_attrs %{apple_photos_id: 42, name: "some name"}
    @update_attrs %{apple_photos_id: 43, name: "some updated name"}
    @invalid_attrs %{apple_photos_id: nil, name: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_person()

      person
    end

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert Api.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Api.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = Api.create_person(@valid_attrs)
      assert person.apple_photos_id == 42
      assert person.name == "some name"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, person} = Api.update_person(person, @update_attrs)
      assert %Person{} = person
      assert person.apple_photos_id == 43
      assert person.name == "some updated name"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_person(person, @invalid_attrs)
      assert person == Api.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Api.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Api.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Api.change_person(person)
    end
  end

  describe "person_images" do
    alias Photog.Api.PersonImage

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def person_image_fixture(attrs \\ %{}) do
      {:ok, person_image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_person_image()

      person_image
    end

    test "list_person_images/0 returns all person_images" do
      person_image = person_image_fixture()
      assert Api.list_person_images() == [person_image]
    end

    test "get_person_image!/1 returns the person_image with given id" do
      person_image = person_image_fixture()
      assert Api.get_person_image!(person_image.id) == person_image
    end

    test "create_person_image/1 with valid data creates a person_image" do
      assert {:ok, %PersonImage{} = person_image} = Api.create_person_image(@valid_attrs)
    end

    test "create_person_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_person_image(@invalid_attrs)
    end

    test "update_person_image/2 with valid data updates the person_image" do
      person_image = person_image_fixture()
      assert {:ok, person_image} = Api.update_person_image(person_image, @update_attrs)
      assert %PersonImage{} = person_image
    end

    test "update_person_image/2 with invalid data returns error changeset" do
      person_image = person_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_person_image(person_image, @invalid_attrs)
      assert person_image == Api.get_person_image!(person_image.id)
    end

    test "delete_person_image/1 deletes the person_image" do
      person_image = person_image_fixture()
      assert {:ok, %PersonImage{}} = Api.delete_person_image(person_image)
      assert_raise Ecto.NoResultsError, fn -> Api.get_person_image!(person_image.id) end
    end

    test "change_person_image/1 returns a person_image changeset" do
      person_image = person_image_fixture()
      assert %Ecto.Changeset{} = Api.change_person_image(person_image)
    end
  end

  describe "album_images" do
    alias Photog.Api.AlbumImage

    @valid_attrs %{order: 42}
    @update_attrs %{order: 43}
    @invalid_attrs %{order: nil}

    def album_image_fixture(attrs \\ %{}) do
      {:ok, album_image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_album_image()

      album_image
    end

    test "list_album_images/0 returns all album_images" do
      album_image = album_image_fixture()
      assert Api.list_album_images() == [album_image]
    end

    test "get_album_image!/1 returns the album_image with given id" do
      album_image = album_image_fixture()
      assert Api.get_album_image!(album_image.id) == album_image
    end

    test "create_album_image/1 with valid data creates a album_image" do
      assert {:ok, %AlbumImage{} = album_image} = Api.create_album_image(@valid_attrs)
      assert album_image.order == 42
    end

    test "create_album_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_album_image(@invalid_attrs)
    end

    test "update_album_image/2 with valid data updates the album_image" do
      album_image = album_image_fixture()
      assert {:ok, album_image} = Api.update_album_image(album_image, @update_attrs)
      assert %AlbumImage{} = album_image
      assert album_image.order == 43
    end

    test "update_album_image/2 with invalid data returns error changeset" do
      album_image = album_image_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_album_image(album_image, @invalid_attrs)
      assert album_image == Api.get_album_image!(album_image.id)
    end

    test "delete_album_image/1 deletes the album_image" do
      album_image = album_image_fixture()
      assert {:ok, %AlbumImage{}} = Api.delete_album_image(album_image)
      assert_raise Ecto.NoResultsError, fn -> Api.get_album_image!(album_image.id) end
    end

    test "change_album_image/1 returns a album_image changeset" do
      album_image = album_image_fixture()
      assert %Ecto.Changeset{} = Api.change_album_image(album_image)
    end
  end

  describe "imports" do
    alias Photog.Api.Import

    @valid_attrs %{import_time: ~N[2010-04-17 14:00:00]}
    @update_attrs %{import_time: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{import_time: nil}

    def import_fixture(attrs \\ %{}) do
      {:ok, import} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_import()

      import
    end

    test "list_imports/0 returns all imports" do
      import = import_fixture()
      assert Api.list_imports() == [import]
    end

    test "get_import!/1 returns the import with given id" do
      import = import_fixture()
      assert Api.get_import!(import.id) == import
    end

    test "create_import/1 with valid data creates a import" do
      assert {:ok, %Import{} = import} = Api.create_import(@valid_attrs)
      assert import.import_time == ~N[2010-04-17 14:00:00]
    end

    test "create_import/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_import(@invalid_attrs)
    end

    test "update_import/2 with valid data updates the import" do
      import = import_fixture()
      assert {:ok, %Import{} = import} = Api.update_import(import, @update_attrs)
      assert import.import_time == ~N[2011-05-18 15:01:01]
    end

    test "update_import/2 with invalid data returns error changeset" do
      import = import_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_import(import, @invalid_attrs)
      assert import == Api.get_import!(import.id)
    end

    test "delete_import/1 deletes the import" do
      import = import_fixture()
      assert {:ok, %Import{}} = Api.delete_import(import)
      assert_raise Ecto.NoResultsError, fn -> Api.get_import!(import.id) end
    end

    test "change_import/1 returns a import changeset" do
      import = import_fixture()
      assert %Ecto.Changeset{} = Api.change_import(import)
    end
  end

  describe "tags" do
    alias Photog.Api.Tag

    @valid_attrs %{apple_photos_uuid: "some apple_photos_uuid", name: "some name"}
    @update_attrs %{apple_photos_uuid: "some updated apple_photos_uuid", name: "some updated name"}
    @invalid_attrs %{apple_photos_uuid: nil, name: nil}

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_tag()

      tag
    end

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Api.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Api.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Api.create_tag(@valid_attrs)
      assert tag.apple_photos_uuid == "some apple_photos_uuid"
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Api.update_tag(tag, @update_attrs)
      assert tag.apple_photos_uuid == "some updated apple_photos_uuid"
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_tag(tag, @invalid_attrs)
      assert tag == Api.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Api.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Api.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Api.change_tag(tag)
    end
  end

  describe "album_tags" do
    alias Photog.Api.AlbumTag

    @valid_attrs %{album_order: 42}
    @update_attrs %{album_order: 43}
    @invalid_attrs %{album_order: nil}

    def album_tag_fixture(attrs \\ %{}) do
      {:ok, album_tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_album_tag()

      album_tag
    end

    test "list_album_tags/0 returns all album_tags" do
      album_tag = album_tag_fixture()
      assert Api.list_album_tags() == [album_tag]
    end

    test "get_album_tag!/1 returns the album_tag with given id" do
      album_tag = album_tag_fixture()
      assert Api.get_album_tag!(album_tag.id) == album_tag
    end

    test "create_album_tag/1 with valid data creates a album_tag" do
      assert {:ok, %AlbumTag{} = album_tag} = Api.create_album_tag(@valid_attrs)
      assert album_tag.album_order == 42
    end

    test "create_album_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_album_tag(@invalid_attrs)
    end

    test "update_album_tag/2 with valid data updates the album_tag" do
      album_tag = album_tag_fixture()
      assert {:ok, %AlbumTag{} = album_tag} = Api.update_album_tag(album_tag, @update_attrs)
      assert album_tag.album_order == 43
    end

    test "update_album_tag/2 with invalid data returns error changeset" do
      album_tag = album_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_album_tag(album_tag, @invalid_attrs)
      assert album_tag == Api.get_album_tag!(album_tag.id)
    end

    test "delete_album_tag/1 deletes the album_tag" do
      album_tag = album_tag_fixture()
      assert {:ok, %AlbumTag{}} = Api.delete_album_tag(album_tag)
      assert_raise Ecto.NoResultsError, fn -> Api.get_album_tag!(album_tag.id) end
    end

    test "change_album_tag/1 returns a album_tag changeset" do
      album_tag = album_tag_fixture()
      assert %Ecto.Changeset{} = Api.change_album_tag(album_tag)
    end
  end
end
