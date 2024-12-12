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

  @doc """
  Converts string to integer greater than or equal to 0. Returns default value on failure
  """
  def string_to_positive_integer(s, default) when is_binary(s) and is_integer(default) do
    string_to_integer(s, default)
    |> max(0)
  end
end
