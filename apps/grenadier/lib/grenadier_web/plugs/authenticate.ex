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
      %User{} = user -> assign(conn, :current_user, user)
      nil -> halt(conn)
    end
  end
end
