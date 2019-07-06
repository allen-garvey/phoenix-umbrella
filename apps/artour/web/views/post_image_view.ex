defmodule Artour.PostImageView do
  use Artour.Web, :view

  @doc """
  How single post image instance should be represented in views
  """
  def display_name(post_image) do
    "Post " <> Integer.to_string(post_image.post_id) <> " Image " <> Integer.to_string(post_image.image_id)
  end

  @doc """
  Renders page to create new post image
  """
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, %{action: post_image_path(assigns[:conn], :create),
                                   heading: Artour.SharedView.form_heading("post image", :new),
                                   save_another: true})

    render "form_page.html", assigns
  end

  @doc """
  Renders page to edit post image
  """
  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, %{action: post_image_path(assigns[:conn], :update, assigns[:post_image]),
                                   heading: Artour.SharedView.form_heading(display_name(assigns[:post_image]), :edit),
                                   show_delete: true})

    render "form_page.html", assigns
  end

  @doc """
  Used on index pages - returns list of attribute names in the
  same order as the attribute_values_short function
  """
  def attribute_names_short() do
    ["Post", "Image", "Caption", "Order"]
  end

  @doc """
  Used on index pages - takes post image instance and returns list of 
  formatted values
  """
  def attribute_values_short(_conn, post_image) do
  	[Artour.PostView.display_name(post_image.post), Artour.ImageView.display_name(post_image.image), post_image.caption, post_image.order]
  end

  @doc """
  Used on show pages - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    attribute_names_short()
  end

  @doc """
  Used on show pages - takes post image instance and returns list of 
  formatted values
  """
  def attribute_values(conn, post_image) do
    [
      link(Artour.PostView.display_name(post_image.post), to: post_path(conn, :show, post_image.post)), 
      link(Artour.ImageView.display_name(post_image.image), to: image_path(conn, :show, post_image.image)), 
      post_image.caption, 
      post_image.order
    ]
  end

end
