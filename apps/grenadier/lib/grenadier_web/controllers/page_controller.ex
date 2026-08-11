defmodule GrenadierWeb.PageController do
  use GrenadierWeb, :controller

  alias Grenadier.Account
  alias Grenadier.Account.User

  plug(:put_view, html: GrenadierWeb.PageView)

  def index(conn, _params) do
    logins = Account.list_logins(10)

    render(conn, "index.html", logins: logins)
  end

  def login(conn, params) do
    redirect_url = params["redirect"]

    case GrenadierWeb.Plugs.Authenticate.get_user_from_session(conn) do
      nil -> render(conn, "login.html", csrf_token: get_csrf_token())
      _ -> redirect_after_login(conn, redirect_url)
    end
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> render("logout.html")
  end

  def login_submit(conn, params = %{"username" => username, "password" => password}) do
    ip = get_remote_ip(conn)

    case authenticate(ip, username, password) do
      {:ok, %User{} = user} ->
        GrenadierWeb.AccessFailedCounter.clear_count(ip)

        conn
        |> generate_login_resource(username, true)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect_after_login(params["redirect"])

      _ ->
        conn
        |> generate_login_resource(username, false)
        |> login_failed(ip, params)
    end
  end

  def login_submit(conn, _params) do
    login_failed(conn, get_remote_ip(conn), nil)
  end

  defp authenticate(ip, username, password) do
    failed_attempts = GrenadierWeb.AccessFailedCounter.get_count(ip)

    cond do
      failed_attempts > 50 ->
        nil

      failed_attempts > 20 ->
        Process.sleep(2000)
        Account.authenticate_user(username, password)

      true ->
        Account.authenticate_user(username, password)
    end
  end

  defp get_header_value(conn, key) do
    Plug.Conn.get_req_header(conn, key) |> List.first()
  end

  defp get_remote_ip(conn) do
    # x-forwarded-for is from Cloudflare https://developers.cloudflare.com/support/troubleshooting/restoring-visitor-ips/restoring-original-visitor-ips
    # otherwise comes from nginx
    case get_header_value(conn, "x-forwarded-for") do
      nil -> get_header_value(conn, "x-real-ip")
      ip -> ip
    end
  end

  defp login_failed(conn, ip, params) do
    GrenadierWeb.AccessFailedCounter.increment_counter(ip)

    query_params =
      case params["redirect"] do
        nil -> []
        _ -> [redirect: params["redirect"]]
      end

    conn
    |> put_flash(:error, "Invalid username or password")
    |> redirect(to: ~p"/login?#{query_params}")
  end

  defp is_request_url_valid?(original_request_url) do
    case original_request_url do
      nil ->
        false

      _ ->
        uri =
          (original_request_url || "")
          |> URI.parse()

        Regex.compile!("#{Common.Endpoint.cookie_domain()}$")
        |> Regex.match?(uri.host || "")
    end
  end

  defp redirect_after_login(conn, original_request_url) do
    case is_request_url_valid?(original_request_url) do
      false ->
        redirect(conn, to: ~p"/admin")

      true ->
        redirect(conn, external: original_request_url)
    end
  end

  @doc """
  Creates login resource to keep record of login attempts
  """
  def generate_login_resource(conn, username, was_successful) do
    user_agent = get_header_value(conn, "user-agent")
    ip = get_remote_ip(conn)

    login_params = %{
      username: username,
      was_successful: was_successful,
      ip: ip,
      user_agent: user_agent
    }

    # don't check if creation fails or not, since we don't want errors
    # saving login attempt to prevent users from logging in
    case Account.create_login(login_params) do
      _ ->
        conn
    end
  end
end
