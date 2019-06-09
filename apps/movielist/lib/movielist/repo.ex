defmodule Movielist.Repo do
  use Ecto.Repo,
    otp_app: :movielist,
    adapter: Ecto.Adapters.Postgres
end
