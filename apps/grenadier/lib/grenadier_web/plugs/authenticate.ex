defmodule GrenadierWeb.Plugs.Authenticate do
  import Plug.Conn

  Code.require_file("config.ex",  "#{__DIR__}/../../../../../lib/common/")

  alias Grenadier.Account
  alias Grenadier.Account.User

  alias GrenadierWeb.Router.Helpers, as: Routes

  # based on authentication plug from programming phoenix

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case get_user_from_session(conn) do
      %User{} = user -> 
        disable_caching(conn) 
        |> assign(:current_user, user)
      nil ->
        conn
        |> disable_caching()
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

  @doc """
  Disables caching for authenticated requests so can't use back button after logging out
  based on: https://stackoverflow.com/questions/33554022/prevent-user-from-accessing-previous-page-using-back-button-after-logout
  """
  def disable_caching(conn) do
    conn
    |> put_resp_header("cache-control", "no-cache, no-store, must-revalidate")
    |> put_resp_header("pragma", "no-cache")
    |> put_resp_header("expires", "0")
  end

  @doc """
  Get the original url to redirect back to after logged in
  """
  def get_request_url(conn) do
    "#{scheme_to_string(conn.scheme)}://#{conn.host}#{get_redirect_port(conn.port)}#{conn.request_path}"
  end

  @doc """
  Gets url to redirect to after failed login
  """
  def get_failed_login_redirect_url(conn) do
    redirect_url_param = conn 
      |> get_request_url
      |> :http_uri.encode
    
    "#{scheme_to_string(conn.scheme)}://#{get_failed_login_redirect_host(conn.host)}#{get_failed_redirect_port(conn.port)}#{Routes.page_path(conn, :login)}?redirect=#{redirect_url_param}"
  end

  @doc """
  Gets host to redirect to in url after failed login
  Does this by using the grenadier subdomain of the current host, or localhost
  """
  def get_failed_login_redirect_host(origin_host) do
    case origin_host do
      "localhost" -> "localhost"
      host        -> host
                     |> String.split(".")
                     |> List.update_at(0, fn _ -> "grenadier" end)
                     |> Enum.join(".")
    end
  end

  @doc """
  Gets the port to redirect to in url after successful login
  """
  def get_redirect_port(origin_port) do
    if origin_port == 80 or origin_port == 443 do
      ""
    else
      ":#{origin_port}"
    end
  end

  @doc """
  Gets the port to redirect back to grenadier after failed login
  """
  def get_failed_redirect_port(origin_port) do
    if origin_port == 80 or origin_port == 443 do
      ""
    else
      ":#{Umbrella.Common.Config.grenadier_port()}"
    end
  end

  @doc """
  Gets the scheme to redirect to in url after failed login
  """
  def scheme_to_string(origin_scheme) do
    case origin_scheme do
      :https -> "https"
      _      -> "http"
    end
  end
end
