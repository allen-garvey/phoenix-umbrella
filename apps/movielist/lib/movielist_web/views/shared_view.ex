defmodule MovielistWeb.SharedView do
  use MovielistWeb, :view

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
  	Takes date or datetime and
  	returns string date in format MM-DD-YYYY
  	"""
  	def us_formatted_date(nil) do
		nil
	end
	def us_formatted_date(datetime) do
		String.pad_leading(Integer.to_string(datetime.month), 2, "0") <> 
		"/" <>
		String.pad_leading(Integer.to_string(datetime.day), 2, "0") <> 
		"/" <>
		Integer.to_string(datetime.year)
	end

	@doc """
	Rounds decimal
	"""
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
