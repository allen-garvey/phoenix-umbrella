defmodule Movielist.AdminTest do
  use Movielist.DataCase

  alias Movielist.Admin

  describe "streamers" do
    alias Movielist.Admin.Streamer

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def streamer_fixture(attrs \\ %{}) do
      {:ok, streamer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_streamer()

      streamer
    end

    test "list_streamers/0 returns all streamers" do
      streamer = streamer_fixture()
      assert Admin.list_streamers() == [streamer]
    end

    test "get_streamer!/1 returns the streamer with given id" do
      streamer = streamer_fixture()
      assert Admin.get_streamer!(streamer.id) == streamer
    end

    test "create_streamer/1 with valid data creates a streamer" do
      assert {:ok, %Streamer{} = streamer} = Admin.create_streamer(@valid_attrs)
      assert streamer.name == "some name"
    end

    test "create_streamer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_streamer(@invalid_attrs)
    end

    test "update_streamer/2 with valid data updates the streamer" do
      streamer = streamer_fixture()
      assert {:ok, %Streamer{} = streamer} = Admin.update_streamer(streamer, @update_attrs)
      assert streamer.name == "some updated name"
    end

    test "update_streamer/2 with invalid data returns error changeset" do
      streamer = streamer_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_streamer(streamer, @invalid_attrs)
      assert streamer == Admin.get_streamer!(streamer.id)
    end

    test "delete_streamer/1 deletes the streamer" do
      streamer = streamer_fixture()
      assert {:ok, %Streamer{}} = Admin.delete_streamer(streamer)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_streamer!(streamer.id) end
    end

    test "change_streamer/1 returns a streamer changeset" do
      streamer = streamer_fixture()
      assert %Ecto.Changeset{} = Admin.change_streamer(streamer)
    end
  end
end
