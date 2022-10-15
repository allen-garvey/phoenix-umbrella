defmodule PluginistaWeb.SharedView do
    use PluginistaWeb, :view

    @doc """
  	Creates a form group container for a label and input
  	"""
	def input_group(field, form, input_fun, input_opts \\ []) when is_atom(field) and is_function(input_fun, 3) and is_list(input_opts) do
		content_tag(:div, [label(form, field), input_fun.(form, field, [class: "form-control"] ++ input_opts), error_tag(form, field)], class: "form-group")
	end
  
    @doc """
  	Creates a form group container with a label, select input, and errors
  	"""
	def select_group(field, form, items) when is_atom(field) do
		content_tag(:div, [label(form, field), select(form, field, items, class: "form-control"), error_tag(form, field)], class: "form-group")
	end
end
  