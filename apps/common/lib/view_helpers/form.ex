defmodule Common.ViewHelpers.Form do
  
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
end