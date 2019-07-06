defmodule Artour.ModelHelpers.SlugValidator do
    import Ecto.Changeset

	@doc """
	Returns true or false based on whether slug
	contains valid characters
	Slug must only contain lowercase letters, numbers and hyphens
	slug cannot begin or end with hyphen and repeating hyphens
	are not allowed
	Slug cannot be empty and cannot be more than 80 characters
	"""
	def is_valid_slug(slug) do
		cond do
			is_nil(slug) -> false
			String.length(slug) == 0 -> false
			String.length(slug) > 80 -> false
			true -> Regex.match?(~r/^[a-z0-9]+(-[a-z0-9]|[a-z0-9])*$/, slug)
		end
	end

	@doc """
	Validate that slug has only valid characters
	"""
	def validate_slug(changeset, slug_key) do
		slug_value = get_field(changeset, slug_key)

		if is_valid_slug(slug_value) do
			changeset
		else
			add_error(changeset, slug_key, "Only lowercase letters, numbers and hyphens are allowed. Cannot begin or end with a hyphen, hyphens cannot repeat and must be less than 80 characters long")
		end
	end
end