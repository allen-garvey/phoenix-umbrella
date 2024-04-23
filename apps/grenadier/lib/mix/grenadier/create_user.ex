defmodule Mix.Tasks.Grenadier.CreateUser do
  use Mix.Task

  alias Grenadier.Account
  alias Common.MixHelpers.Error
  alias Mix.Tasks.Grenadier.Helpers.Input

  @moduledoc """
  Creates a new user
  """
  @doc """
  Creates a new user
  """
  def run([]) do
    create_user()
  end

  def run(_args) do
  	Error.exit_with_error("usage: mix grenadier.create_user")
  end

  def create_user() do
    #start app so repo is available
    Mix.Task.run "app.start", []

    user_name = Input.get_input_with_min_length("Enter user name: ", 5)
    user_password = Input.get_input_with_min_length("Enter password: ", 8)

    case Account.create_user(%{name: user_name, password: user_password}) do
      {:ok, user} ->
        IO.puts "#{user.name} created"

      {:error, %Ecto.Changeset{} = changeset} ->
        Common.MixHelpers.Changeset.errors_to_string(changeset)
        |> Error.exit_with_error(:could_not_create_user)
    end
  end

end
