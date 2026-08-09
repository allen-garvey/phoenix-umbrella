defmodule GrenadierWeb.Plugs.Authenticate do
  import Plug.Conn

  use Phoenix.VerifiedRoutes, router: GrenadierWeb.Router, endpoint: GrenadierWeb.Endpoint

  Code.require_file("config.ex", "#{__DIR__}/../../../../../lib/common/")

  alias Grenadier.Account
  alias Grenadier.Account.User

  # based on authentication plug from programming phoenix

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    case get_user_from_session(conn) do
      %User{} = user ->
        disable_caching(conn, Keyword.get(opts, :disable_cache, true))
        |> assign(:current_user, user)

      nil ->
        conn
        |> disable_caching(true)
        |> Phoenix.Controller.redirect(external: get_failed_login_redirect_url(conn))
        |> halt()
    end
  end

  @doc """
  Returns either the user struct attached to current session or nil
  """
  def get_user_from_session(conn) do
    user_id = get_session(conn, :user_id)
    user_id && Account.get_user(user_id)
  end

  # Disables caching for authenticated requests so can't use back button after logging out
  # based on: https://stackoverflow.com/questions/33554022/#prevent-user-from-accessing-previous-page-using-back-button-after-logout
  defp disable_caching(conn, true) do
    conn
    |> put_resp_header("cache-control", "no-cache, no-store, must-revalidate")
    |> put_resp_header("pragma", "no-cache")
    |> put_resp_header("expires", "0")
  end

  defp disable_caching(conn, false) do
    conn
    |> put_resp_header("cache-control", "private, max-age=86400")
  end

  defp get_request_url(conn) do
    "#{scheme_to_string(conn.scheme)}://#{conn.host}#{conn.request_path}"
  end

  defp get_failed_login_redirect_url(conn) do
    redirect_url_param = URI.encode_query(%{"redirect" => get_request_url(conn)})

    "#{scheme_to_string(conn.scheme)}://#{get_failed_login_redirect_host(conn.host)}#{~p"/login"}?#{redirect_url_param}"
  end

  defp get_failed_login_redirect_host(origin_host) do
    case origin_host do
      "localhost" ->
        "localhost"

      host ->
        host
        |> String.split(".")
        |> List.update_at(0, fn _ -> "grenadier" end)
        |> Enum.join(".")
    end
  end

  defp scheme_to_string(origin_scheme) do
    case origin_scheme do
      :https -> "https"
      _ -> "http"
    end
  end
end
