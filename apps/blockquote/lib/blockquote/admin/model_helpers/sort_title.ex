defmodule Blockquote.Admin.ModelHelpers.SortTitle do
    import Ecto.Changeset

	@doc """
	Returns a sort title by taking a title and converting to lowercase and removing leading articles
	"""
	defp sort_title_from_title(nil) do
		nil
	end

	defp sort_title_from_title(title) do
		Regex.replace(~r/^the\s+/, String.downcase(title), "")
	end

	@doc """
	Validate that slug has only valid characters
	"""
	def generate_sort_title(changeset, title_key, sort_title_key) do
		sort_title_value = get_field(changeset, title_key) |> sort_title_from_title
		change(changeset, %{sort_title_key => sort_title_value})
	end
end