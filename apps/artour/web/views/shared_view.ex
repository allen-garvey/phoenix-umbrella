defmodule Artour.SharedView do
	use Artour.Web, :view

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

	@doc """
  	Used to generate name for path helper function
  	"""
	def item_path_func_name(item_name_singular) do
		String.to_atom(String.replace(item_name_singular, " ", "_") <> "_path")
	end

	@doc """
  	Returns path for item
  	(e.g. :index, :show, :new)
  	"""
	def path_for_item(conn, item_name_singular, path_atom) do
		apply(Artour.Router.Helpers, item_path_func_name(item_name_singular), [conn, path_atom])
	end

	@doc """
  	Returns path for item instance
  	(e.g. :edit and :show)
  	"""
	def path_for_item(conn, item_name_singular, path_atom, item_instance) do
		apply(Artour.Router.Helpers, item_path_func_name(item_name_singular), [conn, path_atom, item_instance])
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