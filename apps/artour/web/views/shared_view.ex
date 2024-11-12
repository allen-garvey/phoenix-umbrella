defmodule Artour.SharedView do
	use Artour.Web, :view

	@doc """
  	Used to generate name for path helper function
  	"""
	def item_path_func_name(item_name_singular) do
		String.to_atom(String.replace(item_name_singular, " ", "_") <> "_path")
	end

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