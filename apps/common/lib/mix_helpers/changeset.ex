defmodule Common.MixHelpers.Changeset do
  alias Ecto.Changeset


  @doc """
  Converts changeset errors to string
  """
  def errors_to_string(changeset) do
    # based on https://hexdocs.pm/ecto/Ecto.Changeset.html#traverse_errors/2
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {key, error_list} ->
      "#{key}: #{Enum.join(error_list, ", ")}"
    end)
    |> Enum.join("\n")
  end

end
