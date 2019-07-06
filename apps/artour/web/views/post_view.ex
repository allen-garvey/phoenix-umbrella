defmodule Artour.PostView do
  use Artour.Web, :view

  @doc """
  How single post instance should be represented in views
  """
  def display_name(post) do
    post.title
  end

  @doc """
  Renders page to create new post
  """
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, %{action: post_path(assigns[:conn], :create),
                                   heading: Artour.SharedView.form_heading("post", :new)})

    render "form_page.html", assigns
  end

  @doc """
  Renders page to edit post
  """
  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, %{action: post_path(assigns[:conn], :update, assigns[:post]),
                                   heading: Artour.SharedView.form_heading(display_name(assigns[:post]), :edit),
                                   show_delete: true})

    render "form_page.html", assigns
  end

  @doc """
  Used to get post admin show pages to highlight cover image
  """
  def is_cover_image(post, image) do
    post.cover_image_id === image.id
  end

  @doc """
  Used on index page - returns abbreviated list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names_short() do
    ["Title", "Thumbnail", "Slug", "NSFW", "Category", "Publication Date"]
  end

  @doc """
  Used on index page - takes post instance and returns abbreviated list of 
  formatted values
  """
  def attribute_values_short(conn, post) do
  	[
      post.title, 
      img_tag(Artour.ImageView.url_for(conn, post.cover_image, :thumbnail, :local), class: "thumbnail-sm"),
      link(post.slug, to: Artour.PublicPostView.show_path(conn, post), class: publication_date_index_cell_class(post.is_published)), 
      content_tag(:div, is_nsfw_index_cell_content(post.is_nsfw), class: is_nsfw_index_cell_class(post.is_nsfw)), 
      Artour.CategoryView.display_name(post.category), 
      content_tag(:div, datetime_to_us_date(post.publication_date), class: publication_date_index_cell_class(post.is_published)), 
    ]
  end

  @doc """
  Returns css class for index table cell
  """
  def publication_date_index_cell_class(is_published) do
    case is_published do
      true  -> ""
      false -> "warning_cell"
    end
  end

  @doc """
  Returns css class for index table cell
  """
  def is_nsfw_index_cell_class(is_nsfw) do
    case is_nsfw do
      true  -> "danger_cell"
      false -> ""
    end
  end

  @doc """
  Returns text content for index table cell
  """
  def is_nsfw_index_cell_content(is_nsfw) do
    case is_nsfw do
      true  -> "yes"
      false -> ""
    end
  end

  @doc """
  Used on show page - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    ["Title", "Public Url", "Publication Date", "Category", "NSFW", "Markdown", "Published", "Body"]
  end

  @doc """
  Used on show page - takes post instance and returns list of 
  formatted values
  """
  def attribute_values(conn, post) do
    [post.title, link(Artour.PublicPostView.show_path(conn, post), to: Artour.PublicPostView.show_path(conn, post)), datetime_to_us_date(post.publication_date), Artour.CategoryView.display_name(post.category), post.is_nsfw, post.is_markdown, post.is_published, to_paragraphs(post.body)]
  end
end
