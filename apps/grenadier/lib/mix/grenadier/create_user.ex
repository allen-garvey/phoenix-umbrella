defmodule Mix.Tasks.Grenadier.CreateUser do
  use Mix.Task

  alias Grenadier.Account
  alias Common.MixHelpers.Error

  @moduledoc """
  Creates a new user
  """
  @doc """
  Creates a new user given the user name and password
  """
  def run([user_name, user_password]) do
    create_user(user_name, user_password)
  end

  def run(_args) do
  	Error.exit_with_error("usage: mix create_user <user_name> <user_password>")
  end

  def create_user(user_name, user_password) do
    #start app so repo is available
    Mix.Task.run "app.start", []

    case Account.create_user(%{name: user_name, password: user_password}) do
      {:ok, user} ->
        IO.puts "#{user.name} created"

      {:error, %Ecto.Changeset{} = changeset} ->
        Common.MixHelpers.Changeset.errors_to_string(changeset)
        |> Error.exit_with_error(:could_not_create_user)
    end

  end

end
