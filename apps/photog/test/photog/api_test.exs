defmodule Photog.ApiTest do
  use Photog.DataCase

  alias Photog.Api

  describe "clans" do
    alias Photog.Api.Clan

    import Photog.ApiFixtures

    @invalid_attrs %{name: nil}

    test "list_clans/0 returns all clans" do
      clan = clan_fixture()
      assert Api.list_clans() == [clan]
    end

    test "get_clan!/1 returns the clan with given id" do
      clan = clan_fixture()
      assert Api.get_clan!(clan.id) == clan
    end

    test "create_clan/1 with valid data creates a clan" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Clan{} = clan} = Api.create_clan(valid_attrs)
      assert clan.name == "some name"
    end

    test "create_clan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_clan(@invalid_attrs)
    end

    test "update_clan/2 with valid data updates the clan" do
      clan = clan_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Clan{} = clan} = Api.update_clan(clan, update_attrs)
      assert clan.name == "some updated name"
    end

    test "update_clan/2 with invalid data returns error changeset" do
      clan = clan_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_clan(clan, @invalid_attrs)
      assert clan == Api.get_clan!(clan.id)
    end

    test "delete_clan/1 deletes the clan" do
      clan = clan_fixture()
      assert {:ok, %Clan{}} = Api.delete_clan(clan)
      assert_raise Ecto.NoResultsError, fn -> Api.get_clan!(clan.id) end
    end

    test "change_clan/1 returns a clan changeset" do
      clan = clan_fixture()
      assert %Ecto.Changeset{} = Api.change_clan(clan)
    end
  end

  describe "clan_persons" do
    alias Photog.Api.ClanPerson

    import Photog.ApiFixtures

    @invalid_attrs %{}

    test "list_clan_persons/0 returns all clan_persons" do
      clan_person = clan_person_fixture()
      assert Api.list_clan_persons() == [clan_person]
    end

    test "get_clan_person!/1 returns the clan_person with given id" do
      clan_person = clan_person_fixture()
      assert Api.get_clan_person!(clan_person.id) == clan_person
    end

    test "create_clan_person/1 with valid data creates a clan_person" do
      valid_attrs = %{}

      assert {:ok, %ClanPerson{} = clan_person} = Api.create_clan_person(valid_attrs)
    end

    test "create_clan_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_clan_person(@invalid_attrs)
    end

    test "update_clan_person/2 with valid data updates the clan_person" do
      clan_person = clan_person_fixture()
      update_attrs = %{}

      assert {:ok, %ClanPerson{} = clan_person} = Api.update_clan_person(clan_person, update_attrs)
    end

    test "update_clan_person/2 with invalid data returns error changeset" do
      clan_person = clan_person_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_clan_person(clan_person, @invalid_attrs)
      assert clan_person == Api.get_clan_person!(clan_person.id)
    end

    test "delete_clan_person/1 deletes the clan_person" do
      clan_person = clan_person_fixture()
      assert {:ok, %ClanPerson{}} = Api.delete_clan_person(clan_person)
      assert_raise Ecto.NoResultsError, fn -> Api.get_clan_person!(clan_person.id) end
    end

    test "change_clan_person/1 returns a clan_person changeset" do
      clan_person = clan_person_fixture()
      assert %Ecto.Changeset{} = Api.change_clan_person(clan_person)
    end
  end
end
