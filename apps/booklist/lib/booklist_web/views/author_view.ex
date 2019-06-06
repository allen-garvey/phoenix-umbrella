defmodule BooklistWeb.AuthorView do
  use BooklistWeb, :view

  def to_s(author) do
    to_s(to_name_first_half(author.first_name, author.middle_name), author.last_name)
  end
  
  def to_s(first_middle, nil) do
    first_middle
  end
  
  def to_s(first_middle, last_name) do
    first_middle <> " " <> last_name
  end
  
  
  def to_sorted_name(author) do
    to_sorted_name(to_name_first_half(author.first_name, author.middle_name), author.last_name)
  end
  
  def to_sorted_name(first_middle, nil) do
    first_middle
  end
  
  def to_sorted_name(first_middle, last_name) do
    last_name <> ", " <> first_middle
  end
  
 
  def to_name_first_half(first_name, nil) do
    first_name
  end
  
  def to_name_first_half(first_name, middle_name) do
    if String.length(middle_name) == 1 do
        first_name <> " " <> middle_name <> ". "
    else
       first_name <> " " <> middle_name <> " "
    end
  end

  @doc """
  Maps a list of authors into tuples, used for forms
  """
  def map_for_form(authors) do
    Enum.map(authors, &{to_sorted_name(&1), &1.id})
  end
end
