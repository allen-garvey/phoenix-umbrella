defmodule BlockquoteWeb.AuthorView do
  use BlockquoteWeb, :view

  def render("new.html", assigns) do
    assigns = Map.merge(assigns, shared_form_assigns())
    render BlockquoteWeb.SharedView, "new.html", assigns
  end

  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, 
      %{
        item: assigns[:author],
        item_display_name: to_s(assigns[:author])
      }
    ) |> Map.merge(shared_form_assigns())
    render BlockquoteWeb.SharedView, "edit.html", assigns
  end

  def shared_form_assigns() do
    %{
        item_name_singular: "author",
        required_fields: Blockquote.Admin.Author.required_fields(), 
        form_fields: form_fields()
      }
  end
  
  
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
  
  def item_columns(_conn, author) do
    [
      {"first name", author.first_name}, 
      {"middle name", author.middle_name}, 
      {"last name", author.last_name},
    ]
  end
  
  
  def form_fields() do
    [
      {:first_name, :string, nil},
      {:middle_name, :string, nil},
      {:last_name, :string, nil},
    ]
  end
  
  
  
  
end
