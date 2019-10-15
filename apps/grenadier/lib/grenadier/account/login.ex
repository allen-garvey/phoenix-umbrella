defmodule Grenadier.Account.Login do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logins" do
    field :attempt_time, :utc_datetime
    field :ip, :string
    field :user_agent, :string
    field :username, :string
    field :was_successful, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(login, attrs) do
    login
    |> cast(attrs, [:attempt_time, :was_successful, :username, :ip, :user_agent])
    |> Common.ModelHelpers.Date.default_datetime_now(:attempt_time)
    |> validate_required([:attempt_time, :was_successful, :ip])
  end
end
