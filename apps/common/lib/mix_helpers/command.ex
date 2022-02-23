defmodule Common.MixHelpers.Command do
    alias Common.MixHelpers.Error
    
    @doc """
    Returns whether a given command is installed on the system
    """
    def is_installed?(command_name) do
        case System.cmd("which", [command_name]) do
            {"", _} -> false
            _  -> true
        end
    end

    @doc """
    Valiates commands needed to run import are installed on system
    """
    def validate_commands_are_installed!(commands) do
        commands
        |> Enum.map(fn command -> 
            if !is_installed?(command)  do
                Error.exit_with_error("#{command} command is not installed or unavailable", :command_not_available)
            end
        end)
  
        true
    end
  
  end
  