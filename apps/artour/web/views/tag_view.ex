defmodule Artour.TagView do
  use Artour.Web, :view

  @doc """
  How single tag instance should be represented in views
  """
  def display_name(tag) do
    tag.name
  end

  @doc """
  Renders page to create new tag
  """
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, %{action: tag_path(assigns[:conn], :create),
                                   heading: Artour.SharedView.form_heading("tag", :new)})

    render "form_page.html", assigns
  end

  @doc """
  Renders page to edit tag
  """
  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, %{action: tag_path(assigns[:conn], :update, assigns[:tag]),
                                   heading: Artour.SharedView.form_heading(display_name(assigns[:tag]), :edit),
                                   show_delete: true})

    render "form_page.html", assigns
  end

  @doc """
  Used on index and show pages - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    ["Name", "Slug"]
  end

  @doc """
  Used on index and show pages - takes tag instance and returns list of 
  formatted values
  """
  def attribute_values(conn, tag) do
  	[
      tag.name, 
      link(tag.slug, to: Artour.PublicTagView.show_path(conn, tag))
    ]
  end
end
