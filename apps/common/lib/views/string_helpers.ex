defmodule Common.StringHelpers do

  @doc """
  Naive implementation of function to pluralize string
  """
	def naive_pluralize(singular) do
		if String.ends_with? singular, "y" do
		  String.replace_trailing(singular, "y", "ies")
		else
			singular <> "s"
		end
	end
end
