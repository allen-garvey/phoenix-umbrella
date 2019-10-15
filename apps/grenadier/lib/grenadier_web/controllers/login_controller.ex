defmodule GrenadierWeb.LoginController do
  use GrenadierWeb, :controller

  alias Grenadier.Account
  alias Grenadier.Account.Login

  def index(conn, _params) do
    logins = Account.list_logins()
    render(conn, "index.html", logins: logins)
  end

  def new(conn, _params) do
    changeset = Account.change_login(%Login{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"login" => login_params}) do
    case Account.create_login(login_params) do
      {:ok, login} ->
        conn
        |> put_flash(:info, "Login created successfully.")
        |> redirect(to: Routes.login_path(conn, :show, login))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    login = Account.get_login!(id)
    render(conn, "show.html", login: login)
  end

  def edit(conn, %{"id" => id}) do
    login = Account.get_login!(id)
    changeset = Account.change_login(login)
    render(conn, "edit.html", login: login, changeset: changeset)
  end

  def update(conn, %{"id" => id, "login" => login_params}) do
    login = Account.get_login!(id)

    case Account.update_login(login, login_params) do
      {:ok, login} ->
        conn
        |> put_flash(:info, "Login updated successfully.")
        |> redirect(to: Routes.login_path(conn, :show, login))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", login: login, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    login = Account.get_login!(id)
    {:ok, _login} = Account.delete_login(login)

    conn
    |> put_flash(:info, "Login deleted successfully.")
    |> redirect(to: Routes.login_path(conn, :index))
  end
end
