defmodule Mix.Tasks.Grenadier.DeleteUser do
    use Mix.Task
  
    alias Grenadier.Account
    alias Grenadier.Account.User
    alias Common.MixHelpers.Error
    alias Mix.Tasks.Grenadier.Helpers.Input
  
    @moduledoc """
    Deletes a user
    """
    @doc """
    Deletes a given user
    """
    def run([]) do
      delete_user()
    end
  
    def run(_args) do
        Error.exit_with_error("usage: mix grenadier.delete_user")
    end
  
    def delete_user() do
      #start app so repo is available
      Mix.Task.run "app.start", []
  
      user_name = Input.get_input_with_min_length("Enter user name: ", 1)
  
      case Account.get_user_by_name(user_name) do
        nil ->
          Error.exit_with_error("Could not find user: #{user_name}", :user_not_found)
  
        %User{} = user ->
          case Input.get_input_with_min_length("Are you sure you want to delete #{user_name}? (yes/no): ", 1) do
            "yes" -> case Account.delete_user(user) do
                {:ok, _} -> IO.puts "User #{user_name} successfully deleted."
                _ -> IO.puts "Delete operation failed."
            end
            _ -> IO.puts "Deleting user #{user_name} cancelled."
          end
      end
  
    end
  
end
  