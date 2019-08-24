defmodule Startpage.Repo do
  use Ecto.Repo,
    otp_app: :startpage,
    adapter: Ecto.Adapters.Postgres
end
