defmodule Common.NumberHelpers do

  @doc """
	Converts decimal type float and rounds to 2 decimal places
	"""
	def round_decimal(nil) do
		0
	end
	def round_decimal(decimal) do
		decimal
		  |> Decimal.to_float
		  |> Float.round(2)
	end
end
