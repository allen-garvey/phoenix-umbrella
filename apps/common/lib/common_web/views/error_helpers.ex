defmodule CommonWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating error messages.
  """
  
  @doc """
  Translates an ecto error message into a string. Error message formats can be found in [Ecto.Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html) validation functions
  """
  def translate_error({msg, opts}) do
    cond do
      count = opts[:count] -> String.replace(msg, "%{count}", Integer.to_string(count))
      number = opts[:number] -> String.replace(msg, "%{number}", Integer.to_string(number))
      true -> msg
    end
  end
end
  