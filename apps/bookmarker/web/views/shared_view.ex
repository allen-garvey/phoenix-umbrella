defmodule Bookmarker.SharedView do
  use Bookmarker.Web, :view

  @doc """
  Takes a string and capitalizes each word in the string
  and adds an 's' at the end (pluralization is not language aware)
  """
  def pluralize_and_capitalize(string) do
  	string |>
  	String.split |>
  	Enum.map(fn(s) -> String.capitalize(s) end) |>
  	Enum.join(" ") |>
  	Common.StringHelpers.naive_pluralize()
  end
end