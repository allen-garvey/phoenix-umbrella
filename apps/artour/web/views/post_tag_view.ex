defmodule Artour.PostTagView do
  use Artour.Web, :view

  @doc """
  How single post tag instance should be represented in views
  """
  def display_name(post_tag) do
    "Post " <> Integer.to_string(post_tag.post_id) <> " Tag " <> Integer.to_string(post_tag.tag_id)
  end

  @doc """
  Renders page to create new post tag
  """
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, %{action: post_tag_path(assigns[:conn], :create),
                                   heading: Artour.SharedView.form_heading("post tag", :new)})

    render "form_page.html", assigns
  end

  @doc """
  Renders page to edit post tag
  """
  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, %{action: post_tag_path(assigns[:conn], :update, assigns[:post_tag]),
                                   heading: Artour.SharedView.form_heading(display_name(assigns[:post_tag]), :edit),
                                   show_delete: true})

    render "form_page.html", assigns
  end

  @doc """
  Used on index pages - returns list of attribute names in the
  same order as the attribute_values_short function
  """
  def attribute_names_short() do
    ["Post", "Tag"]
  end

  @doc """
  Used on index pages - takes post tag instance and returns list of 
  formatted values
  """
  def attribute_values_short(_conn, post_tag) do
  	[Artour.PostView.display_name(post_tag.post), Artour.TagView.display_name(post_tag.tag)]
  end

  @doc """
  Used on show pages - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    attribute_names_short()
  end

  @doc """
  Used on show pages - takes post tag instance and returns list of 
  formatted values
  """
  def attribute_values(conn, post_tag) do
    [
      link(Artour.PostView.display_name(post_tag.post), to: post_path(conn, :show, post_tag.post)), 
      link(Artour.TagView.display_name(post_tag.tag), to: tag_path(conn, :show, post_tag.tag))
    ]
  end
end
