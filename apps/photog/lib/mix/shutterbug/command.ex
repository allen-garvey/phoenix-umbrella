defmodule Photog.Shutterbug.Command do
  alias Photog.Shutterbug.Error

  @doc """
  Returns whether a given command is installed on the system
  """
  def is_command_available(command_name) do
    case System.cmd("which", [command_name]) do
      {"", _} -> false
      _  -> true
    end
  end

  @doc """
  Valiates commands needed to run import are installed on system
  """
  def are_import_commands_available do
    ["convert", "exiftool"]
    |> Enum.map(fn command -> 
      if !is_command_available(command)  do
        Error.exit_with_error("#{command} command is not installed or unavailable", :command_not_available)
      end
    end)
    
    true
  end

end
