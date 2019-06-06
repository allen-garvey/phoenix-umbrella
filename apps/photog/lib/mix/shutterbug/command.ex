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
    image_magick_command = "convert"
    exiftool_command = "exiftool"
    if !is_command_available(image_magick_command)  do
      Error.exit_with_error("Image magick '#{image_magick_command}' command is not installed or unavailable", :image_magick_not_available)
    end
    if !is_command_available(image_magick_command) do
      Error.exit_with_error("'#{exiftool_command}' command is not installed or unavailable", :exiftool_not_available)
    end
    true
  end

end
