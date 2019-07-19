defmodule GrenadierWeb.Plugs.Authenticate do
  import Plug.Conn

  alias Grenadier.Account
  alias Grenadier.Account.User

  # based on authentication plug from programming phoenix

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    case user_id && Account.get_user(user_id) do
      %User{} = user -> disable_caching(conn) |> assign(:current_user, user)
      nil ->
        # IO.inspect conn
        # TODO change to redirect to remove subdomain from host and replace with grenadier
        # and add grenadier login path user Routes
        conn
        |> disable_caching()
        |> Phoenix.Controller.redirect(external: "http://" <> conn.host)
        |> halt()
    end
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
end
