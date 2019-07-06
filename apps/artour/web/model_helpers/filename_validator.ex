defmodule Artour.ModelHelpers.FilenameValidator do
    import Ecto.Changeset

	@doc """
	Returns true or false based on whether image filename
	contains valid characters
	Filename must only contain lowercase letters, numbers and hyphens
	Must contain file extension of jpg, jpeg, png or svg
	filename cannot begin or end with hyphen and repeating hyphens
	are not allowed
	filename cannot be empty and cannot be more than 80 characters
	"""
	def is_valid_image_filename(image_filename) do
		cond do
			is_nil(image_filename) -> false
			String.length(image_filename) == 0 -> false
			String.length(image_filename) > 80 -> false
			true -> Regex.match?(~r/^[a-z0-9]*(-[a-z0-9]|[a-z0-9])*\.(jpg|jpeg|png|svg)$/, image_filename)
		end
	end

	@doc """
	Validate that image filename has only valid characters
	"""
	def validate_image_filename(changeset, image_filename_key) do
		image_filename = get_field(changeset, image_filename_key)

		if is_valid_image_filename(image_filename) do
			changeset
		else
			add_error(changeset, image_filename_key, "Invalid filename. Only lowercase letters, numbers and hyphens are allowed. Cannot begin or end with a hyphen, hyphens cannot repeat and must be less than 80 characters long. Must have image file extension (.jpg, .jpeg, .png or .svg)")
		end
	end
end