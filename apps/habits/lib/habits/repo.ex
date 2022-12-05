defmodule Habits.Repo do
  use Ecto.Repo,
    otp_app: :habits,
    adapter: Ecto.Adapters.Postgres
end
