defmodule GrenadierWeb.PageController do
  use GrenadierWeb, :controller

  alias Grenadier.Account
  alias Grenadier.Account.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    render conn, "login.html", csrf_token: get_csrf_token()
  end

  def login_submit(conn, %{"username" => username, "password" => password}) do
    case Account.authenticate_user(username, password) do
      {:ok, %User{} = user} -> conn
                      |> put_session(:user_name, user.name)
                      |> configure_session(renew: true)
                      |> render("index.html")
      _   -> login(conn, nil)
    end
  end
end
