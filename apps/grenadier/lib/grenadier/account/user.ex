defmodule Grenadier.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password_hash, :string, redact: true

    field :password, :string, virtual: true, redact: true

    timestamps()
  end

  defp put_pass_hash(
    %Ecto.Changeset{
      valid?: true,
      changes: %{password: password}} = changeset
  ) when not is_nil(password) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_length(:password, min: 8)
    |> put_pass_hash
    |> validate_required([:password_hash])
    |> unique_constraint(:name)
  end
end
