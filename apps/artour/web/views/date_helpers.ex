# For code shared across views that relates to whole application
defmodule Artour.DateHelpers do

	@doc """
  	Takes integer representing month
  	returns full English month-name
  	"""
	def to_month_name(month_number) do
		case month_number do
		  1 -> "January"
		  2 -> "February"
		  3 -> "March"
		  4 -> "April"
		  5 -> "May"
		  6 -> "June"
		  7 -> "July"
		  8 -> "August"
		  9 -> "September"
		  10 -> "October"
		  11 -> "November"
		  12 -> "December"
		end
	end

	@doc """
  	Takes datetime string as argument
  	returns string date in format `Month name DD, YYYY`
  	"""
	def datetime_to_display_date(datetime) do
		to_month_name(datetime.month) <> 
		" " <>
		String.pad_leading(Integer.to_string(datetime.day), 2, "0") <> 
		", " <>
		Integer.to_string(datetime.year)
	end
end