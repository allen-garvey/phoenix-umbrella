defmodule Common.ModelHelpers.Number do
  alias Ecto.Changeset

  @doc """
  Validates rating score is between 1-100
  """
  def validate_score(changeset, attribute_key) do
    score = Changeset.get_field(changeset, attribute_key)
    if !is_integer(score) or score < 1 or score > 100 do
      Changeset.add_error(changeset, attribute_key, "Score must be between 1-100")
    else
      changeset
    end
  end

  def format_currency(nil) do
    format_currency("0", "00")
  end

  def format_currency(%Decimal{} = decimal) do
    case Decimal.to_string(decimal) |> String.split(".") do
      [integer_string] -> format_currency(integer_string, "")
      [integer_string, fractional_string] -> format_currency(integer_string, fractional_string)
    end
  end

  def format_currency(integer_string, fractional_string) when is_binary(integer_string) and is_binary(fractional_string) do
    formatted_integer_string = 
      integer_string
      |> String.to_charlist
      |> Enum.reverse
      |> Enum.chunk_every(3)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.reverse
      |> Enum.join(",")

    case fractional_string do
      "" -> "$#{formatted_integer_string}"
      _  -> "$#{formatted_integer_string}.#{fractional_string}"
    end
  end

end
