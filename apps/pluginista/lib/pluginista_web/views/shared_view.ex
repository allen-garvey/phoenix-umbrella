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
	def select_group(field, form, items, input_opts \\ []) when is_atom(field) do
		content_tag(:div, [label(form, field), select(form, field, items, [class: "form-control"] ++ input_opts), error_tag(form, field)], class: "form-group")
	end

	@doc """
  	Creates list of checkboxes for shared field
	based on: https://elixirforum.com/t/checkboxes-as-lists-of-ids-common-case/29293/2
  	"""
	def multiselect_checkboxes(form, field, options, selected_options, opts \\ []) 
		when is_atom(field) and is_list(options) and is_map(selected_options) do
	
		# Use inline mode by default
		class = opts[:class] || "form-check form-check-inline"
	
		for {name, key} <- options, into: [] do
			id = input_id(form, field, key)
			content_tag(:div, class: class) do
				[
					tag(
						:input,
						name: input_name(form, field) <> "[]",
						id: id,
						class: "form-check-input",
						type: "checkbox",
						value: key,
						checked: Map.has_key?(selected_options, key)
					),
					content_tag(:label, name, class: "form-check-label", for: id)
				]
			end
		end
	end
end
  