defmodule Pluginista.Repo do
  use Ecto.Repo,
    otp_app: :pluginista,
    adapter: Ecto.Adapters.Postgres
end
