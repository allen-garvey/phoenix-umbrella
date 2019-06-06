defmodule PhotogWeb.DatetimeHelpers do

	def to_us_formatted_date(datetime) do
		"#{digit_pad_2(datetime.month)}/#{digit_pad_2(datetime.day)}/#{datetime.year}"
	end

	def to_formatted_time(datetime) do
		"#{digit_pad_2(datetime.hour)}:#{digit_pad_2(datetime.minute)}:#{digit_pad_2(datetime.second)}"
	end

	def digit_pad_2(digit) do
		digit
		|> Integer.to_string
		|> String.pad_leading(2, "0")
	end

end