defmodule Artour.SharedView do
	use Artour.Web, :view

	@doc """
  	Used as heading for new  and edit item form
  	for :new, item_name should be item_name_singular
  	for :edit, item_name should be item display_name
  	"""
  	def form_heading(item_name, form_type) do
  		if form_type == :edit do
  			"Edit " <> item_name
  		else
  			"New " <> item_name
  		end
  	end

end