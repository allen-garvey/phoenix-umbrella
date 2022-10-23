defmodule Common.ViewHelpers.Form do
  use Phoenix.HTML
  import Common.ViewHelpers.Error
  
  @doc """
  Defines a function to map a list of resources into tuples, used for forms
  There must be an existing to_s() function in the module
  to transform the resource into a string
  """
  defmacro define_map_for_form do
    quote do
      def map_for_form(resources) do
        Enum.map(resources, &{to_s(&1), &1.id})
      end
    end
  end

  @doc """
  Defines a function to map a list of resources into tuples, used for forms
  Uses the resource name attribute
  """
  defmacro define_map_for_form_default do
    quote do
      def map_for_form(resources) do
        Enum.map(resources, &{&1.name, &1.id})
      end
    end
  end

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
end