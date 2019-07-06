defmodule Artour.CategoryView do
  use Artour.Web, :view

  @doc """
  How single category instance should be represented in views
  """
  def display_name(category) do
    category.name
  end

  @doc """
  Renders page to create new category
  """
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, %{action: category_path(assigns[:conn], :create),
                                   heading: Artour.SharedView.form_heading("category", :new)})

    render "form_page.html", assigns
  end

  @doc """
  Renders page to edit category
  """
  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, %{action: category_path(assigns[:conn], :update, assigns[:category]),
                                   heading: Artour.SharedView.form_heading(display_name(assigns[:category]), :edit),
                                   show_delete: true})

    render "form_page.html", assigns
  end

  @doc """
  Used on index and show pages - transforms category type integer into title-case
  string
  """
  def category_type_name(category_type_value) do
    Artour.CategoryType.name(category_type_value) |> String.capitalize
  end

  @doc """
  Used on index and show pages - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    ["Name", "Slug", "Type"]
  end

  @doc """
  Used on index and show pages - takes category instance and returns list of 
  formatted values
  """
  def attribute_values(conn, category) do
  	[
      category.name, 
      link(category.slug, to: Artour.PublicCategoryView.show_path(conn, category)),
      category_type_name(category.type)
    ]
  end

end
