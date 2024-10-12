defmodule PluginistaWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pluginista

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :pluginista,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    # socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    # plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    # plug Phoenix.Ecto.CheckRepoStatus, otp_app: :pluginista
  end

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, Common.Endpoint.session_options()
  plug PluginistaWeb.Router
end
