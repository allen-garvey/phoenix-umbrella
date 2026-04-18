defmodule GrenadierWeb.LoginController do
  use GrenadierWeb, :controller

  alias Grenadier.Account

  plug(:put_view, html: GrenadierWeb.LoginView)

  def index(conn, _params) do
    logins = Account.list_logins()
    render(conn, "index.html", logins: logins)
  end

  def show(conn, %{"id" => id}) do
    login = Account.get_login!(id)
    render(conn, "show.html", login: login)
  end

  def delete(conn, %{"id" => id}) do
    login = Account.get_login!(id)
    {:ok, _login} = Account.delete_login(login)

    conn
    |> put_flash(:info, "Login deleted successfully.")
    |> redirect(to: ~p"/admin/logins")
  end
end
