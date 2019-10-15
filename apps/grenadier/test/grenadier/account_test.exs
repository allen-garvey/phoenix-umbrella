defmodule Grenadier.AccountTest do
  use Grenadier.DataCase

  alias Grenadier.Account

  describe "users" do
    alias Grenadier.Account.User

    @valid_attrs %{name: "some name", password_hash: "some password_hash"}
    @update_attrs %{name: "some updated name", password_hash: "some updated password_hash"}
    @invalid_attrs %{name: nil, password_hash: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.name == "some name"
      assert user.password_hash == "some password_hash"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.name == "some updated name"
      assert user.password_hash == "some updated password_hash"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "logins" do
    alias Grenadier.Account.Login

    @valid_attrs %{attempt_time: ~N[2010-04-17 14:00:00], ip: "some ip", user_agent: "some user_agent", username: "some username", was_successful: true}
    @update_attrs %{attempt_time: ~N[2011-05-18 15:01:01], ip: "some updated ip", user_agent: "some updated user_agent", username: "some updated username", was_successful: false}
    @invalid_attrs %{attempt_time: nil, ip: nil, user_agent: nil, username: nil, was_successful: nil}

    def login_fixture(attrs \\ %{}) do
      {:ok, login} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_login()

      login
    end

    test "list_logins/0 returns all logins" do
      login = login_fixture()
      assert Account.list_logins() == [login]
    end

    test "get_login!/1 returns the login with given id" do
      login = login_fixture()
      assert Account.get_login!(login.id) == login
    end

    test "create_login/1 with valid data creates a login" do
      assert {:ok, %Login{} = login} = Account.create_login(@valid_attrs)
      assert login.attempt_time == ~N[2010-04-17 14:00:00]
      assert login.ip == "some ip"
      assert login.user_agent == "some user_agent"
      assert login.username == "some username"
      assert login.was_successful == true
    end

    test "create_login/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_login(@invalid_attrs)
    end

    test "update_login/2 with valid data updates the login" do
      login = login_fixture()
      assert {:ok, %Login{} = login} = Account.update_login(login, @update_attrs)
      assert login.attempt_time == ~N[2011-05-18 15:01:01]
      assert login.ip == "some updated ip"
      assert login.user_agent == "some updated user_agent"
      assert login.username == "some updated username"
      assert login.was_successful == false
    end

    test "update_login/2 with invalid data returns error changeset" do
      login = login_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_login(login, @invalid_attrs)
      assert login == Account.get_login!(login.id)
    end

    test "delete_login/1 deletes the login" do
      login = login_fixture()
      assert {:ok, %Login{}} = Account.delete_login(login)
      assert_raise Ecto.NoResultsError, fn -> Account.get_login!(login.id) end
    end

    test "change_login/1 returns a login changeset" do
      login = login_fixture()
      assert %Ecto.Changeset{} = Account.change_login(login)
    end
  end
end
