defmodule MovielistWeb.SharedView do
  use MovielistWeb, :view

	@doc """
	Rounds decimal
	"""
	def round_decimal(nil) do
		0
	end
	def round_decimal(decimal) do
		decimal
		  |> Decimal.to_float
		  |> Float.round(2)
	end

	@doc """
  	Creates a form group container for a label and input
  	"""
	def form_group(field, form, fun) when is_atom(field) and is_function(fun, 3) do
		content_tag(:div, [label(form, field), fun.(form, field, class: "form-control"), error_tag(form, field)], class: "form-group")
	end

	@doc """
  	Creates a form group container with a label, input, and errors (used for select boxes)
  	"""
	def form_group(field, form, items, fun) when is_atom(field) and is_function(fun, 4) do
		content_tag(:div, [label(form, field), fun.(form, field, items, class: "form-control"), error_tag(form, field)], class: "form-group")
	end

	def submit_button(resource_title) do
		content_tag(:div, submit("Save " <> resource_title, class: "btn btn-success"))
	end

end
