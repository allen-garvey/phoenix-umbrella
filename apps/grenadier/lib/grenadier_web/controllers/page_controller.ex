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
                      |> generate_login_resource(username, true)
                      |> put_session(:user_id, user.id)
                      |> configure_session(renew: true)
                      |> redirect_after_login()
      _   -> conn
              |> generate_login_resource(username, false)
              |> login_failed()
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
      nil -> redirect(conn, to: Routes.page_path(conn, :index))
      original_request_url ->
        delete_session(conn, :original_request_url)
        |> redirect(external: original_request_url)
    end
  end

  @doc """
  Creates login resource to keep record of login attempts
  """
  def generate_login_resource(conn, username, was_successful) do
    [user_agent] = get_req_header(conn, "user-agent")
    remote_ip = conn.remote_ip
                  |> Tuple.to_list
                  |> Enum.join(".")
    login_params = %{
      username: username,
      was_successful: was_successful,
      ip: remote_ip,
      user_agent: user_agent,
    }
    # don't check if creation fails or not, since we don't want errors
    # saving login attempt to prevent users from logging in
    case Account.create_login(login_params) do
      _ ->
        conn
    end
  end
end
