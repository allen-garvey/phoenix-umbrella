defmodule Artour.FormatView do
  use Artour.Web, :view

  @doc """
  How single format instance should be represented in views
  """
  def display_name(format) do
    format.name
  end

  @doc """
  Renders page to create new format
  """
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, %{action: format_path(assigns[:conn], :create),
                                   heading: Artour.SharedView.form_heading("format", :new)})

    render "form_page.html", assigns
  end

  @doc """
  Renders page to edit format
  """
  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, %{action: format_path(assigns[:conn], :update, assigns[:format]),
                                   heading: Artour.SharedView.form_heading(display_name(assigns[:format]), :edit),
                                   show_delete: true})

    render "form_page.html", assigns
  end

  @doc """
  Used on index and show pages - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    ["Name"]
  end

  @doc """
  Used on index and show pages - takes format instance and returns list of 
  formatted values
  """
  def attribute_values(_conn, format) do
  	[format.name]
  end

end
