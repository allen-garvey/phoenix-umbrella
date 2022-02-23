defmodule Photog.Shutterbug.FileValidator do
  alias Common.MixHelpers.Error

  def validate_import_directory!(directory_path) do
    cond do
  		!File.exists?(directory_path) -> Error.exit_with_error("#{directory_path} does not exist")
  		!File.dir?(directory_path)    -> Error.exit_with_error("#{directory_path} is not a directory")
  		true						              -> true
  	end
  end

end
