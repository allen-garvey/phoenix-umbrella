defmodule Artour.Guggenheim.Error do

    @doc """
    Exits program with error message
    """
    def exit_with_error(error_message, reason \\ :invalid_commandline_arguments) do
        IO.puts :stderr, error_message
        exit(reason)
    end
  
  end
  