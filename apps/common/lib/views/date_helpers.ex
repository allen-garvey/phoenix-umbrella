defmodule Common.DateHelpers do

  @doc """
  Takes a date or datetime struct and returns a string in us format
  mm/dd/yyyy separated by the separator string
  """
  def us_formatted_date(datetime, separator \\ "/")

  def us_formatted_date(nil, _separator) do
    nil
  end

	def us_formatted_date(datetime, separator) do
    "#{integer_pad_2(datetime.month)}#{separator}#{integer_pad_2(datetime.day)}#{separator}#{datetime.year}"
  end

  @doc """
  Returns time from datetime as string formatted as HH:MM:SS
  """
  def formatted_time(datetime) do
    "#{integer_pad_2(datetime.hour)}:#{integer_pad_2(datetime.minute)}:#{integer_pad_2(datetime.second)}"
  end

  @doc """
  Transforms an integer to a string with 2 digits
  """
  def integer_pad_2(integer) do
		integer
		|> Integer.to_string
		|> String.pad_leading(2, "0")
	end
end
