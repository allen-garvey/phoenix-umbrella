defmodule Artour.CategoryType do
  
  @doc """
  Returns a list of valid values - functions as enum
  If adding values, add to end and do not reorder it, as this
  will affect values stored in database
  """
  def values() do
    [:album, :audio, :video]
  end

  @doc """
  Returns the name atom that a value maps to
  does no error checking beforehand that value is valid
  should call is_valid beforehand
  """
  def name_atom(int_value) do
    values() |> Enum.at(int_value - 1)
  end

  @doc """
  Returns the string name that a value maps to
  does no error checking beforehand that value is valid
  should call is_valid beforehand
  """
  def name(int_value) do
    name_atom(int_value) |> to_string
  end

  @doc """
  Returns a boolean value for whether value is valid
  CategoryType
  """
  def is_valid(value) do
    is_integer(value) and value > 0 and value <= length(values())
  end

  @doc """
  Returns list of category types with name and index
  suitable for select fields
  for forms
  """
  def form_list() do
    values() 
      |> Enum.map(&(to_string(&1) |> String.capitalize))
      |> Enum.with_index(1) 
      |> Enum.sort_by(&(elem(&1, 0)))
  end

end
