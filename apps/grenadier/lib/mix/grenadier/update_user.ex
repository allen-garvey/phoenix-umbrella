defmodule Mix.Tasks.Grenadier.UpdateUser do
  use Mix.Task

  alias Grenadier.Account
  alias Grenadier.Account.User
  alias Common.MixHelpers.Error

  @moduledoc """
  Update's an existing user's password
  """
  @doc """
  Updates the password for the given user
  """
  def run([user_name, user_password]) do
    update_user(user_name, user_password)
  end

  def run(_args) do
  	Error.exit_with_error("usage: mix grenadier.update_user <user_name> <user_password>")
  end

  def update_user(user_name, user_password) do
    #start app so repo is available
    Mix.Task.run "app.start", []

    case Account.get_user_by_name(user_name) do
      nil ->
        Error.exit_with_error("Could not find user: #{user_name}", :user_not_found)

      %User{} = user ->
        case Account.update_user(user, %{password: user_password}) do
          {:ok, user} ->
            IO.puts "Password for user #{user.name} updated"

          {:error, %Ecto.Changeset{} = changeset} ->
            Common.MixHelpers.Changeset.errors_to_string(changeset)
            |> Error.exit_with_error(:could_not_create_user)
        end
    end

  end

end
