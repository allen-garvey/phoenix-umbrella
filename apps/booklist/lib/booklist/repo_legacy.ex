defmodule Booklist.RepoLegacy do
  use Ecto.Repo,
    otp_app: :booklist,
    adapter: Ecto.Adapters.Postgres
end
