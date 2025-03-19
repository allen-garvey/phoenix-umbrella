defmodule Common.NumberHelpers do
  @doc """
  Converts decimal type float and rounds to 2 decimal places
  """
  def round_decimal(nil) do
    0
  end

  def round_decimal(decimal) do
    decimal
    |> Decimal.to_float()
    |> Float.round(2)
  end

  @doc """
  Converts string to integer. Returns default value on failure
  """
  def string_to_integer(s, default) when is_binary(s) and is_integer(default) do
    case Integer.parse(s) do
      {number, _} -> number
      :error -> default
    end
  end

  def string_to_integer_with_min(s, default, min_value \\ 0) do
    string_to_integer(s, default)
    |> max(min_value)
  end
end
