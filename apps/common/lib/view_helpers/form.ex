defmodule Common.ViewHelpers.Form do
  use PhoenixHTMLHelpers

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, CommonWeb.ErrorHelpers.translate_error(error), class: "help-block")
    end)
  end
  
  @doc """
  Defines a function to map a list of resources into tuples, used for forms
  There must be an existing to_s() function in the module
  to transform the resource into a string
  """
  defmacro define_map_for_form(define_to_s \\ false) do
    if define_to_s do
      quote do
        def to_s(resource) do
          resource.name
        end

        def map_for_form(resources) do
          Enum.map(resources, &{to_s(&1), &1.id})
        end
      end

      else
        quote do
          def map_for_form(resources) do
            Enum.map(resources, &{to_s(&1), &1.id})
          end
        end
    end
  end

  defp label_for_input(field, form, input_opts) do
    {label_text, input_opts_cleaned_1} = Keyword.pop_first(input_opts, :label)
    {label_class, input_opts_cleaned_2} = Keyword.pop_first(input_opts_cleaned_1, :label_class, "")

    input_label = case label_text do
      nil -> label(form, field, class: label_class)
      _ -> label(form, field, label_text, class: label_class)
    end

    {input_label, input_opts_cleaned_2}
  end

  @doc """
  Creates a form group container for a label and input
  """
	def input_group(field, form, input_fun, input_opts \\ []) when is_atom(field) and is_function(input_fun, 3) and is_list(input_opts) do
    {input_label, input_opts_cleaned} = label_for_input(field, form, input_opts)

	  content_tag(:div, [input_label, input_fun.(form, field, Keyword.put_new(input_opts_cleaned, :class, "form-control")), error_tag(form, field)], class: "form-group")
	end

  @doc """
  Creates a form group container for a checkbox with a label
  """
	def checkbox_input_group(field, form, input_opts \\ []) when is_atom(field) and is_list(input_opts) do
	  input_group(field, form, &checkbox/3, Keyword.put_new(input_opts, :class, "form-check-input"))
	end

  @doc """
  Creates a form group container for a date input with a label, input and yesterday button
  """
	def date_input_group(field, form) when is_atom(field) do
	  content_tag(:div, [
        label(form, field), 
        date_input(form, field, [class: "form-control"]), 
        content_tag(:button, "Yesterday", [class: "btn btn-light btn-lg", data_button: "yesterday", type: "button"]), 
        error_tag(form, field)
      ], 
      class: "form-group form-group-inline",
      data_date_input_group: true)
	end
  
  @doc """
  Creates a form group container with a label, select input, and errors
  """
	def select_group(field, form, items, input_opts \\ []) when is_atom(field) do
    {input_label, input_opts_cleaned} = label_for_input(field, form, input_opts)

		content_tag(:div, [input_label, select(form, field, items, Keyword.put_new(input_opts_cleaned, :class, "form-control")), error_tag(form, field)], class: "form-group")
	end
end