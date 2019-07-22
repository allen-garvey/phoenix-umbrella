defmodule GrenadierWeb.PageController do
  use GrenadierWeb, :controller

  alias Grenadier.Account
  alias Grenadier.Account.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    case  GrenadierWeb.Plugs.Authenticate.get_user_from_session(conn) do
      nil -> render conn, "login.html", csrf_token: get_csrf_token()
      _   -> redirect_after_login(conn)
    end
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> render("logout.html")
  end

  def login_submit(conn, %{"username" => username, "password" => password}) do
    case Account.authenticate_user(username, password) do
      {:ok, %User{} = user} -> conn
                      |> put_session(:user_id, user.id)
                      |> configure_session(renew: true)
                      |> redirect_after_login()
      _   -> login_failed(conn)
    end
  end

  def login_submit(conn, _params) do
    login_failed(conn)
  end

  defp login_failed(conn) do
    conn
    |> put_flash(:error, "Invalid username or password")
    |> login(nil)
  end

  defp redirect_after_login(conn) do
    case get_session(conn, :original_request_url) do
      nil -> redirect(conn, to: Routes.user_path(conn, :index))
      original_request_url ->
        delete_session(conn, :original_request_url)
        |> redirect(external: original_request_url)
    end
  end
end
