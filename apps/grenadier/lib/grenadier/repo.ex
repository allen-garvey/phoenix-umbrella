defmodule Grenadier.Repo do
  use Ecto.Repo,
    otp_app: :grenadier,
    adapter: Ecto.Adapters.Postgres
end
