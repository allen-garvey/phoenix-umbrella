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
    ["Title", "Thumbnail", "Slug", "NSFW", "Publication Date"]
  end

  @doc """
  Used on index page - takes post instance and returns abbreviated list of 
  formatted values
  """
  def attribute_values_short(conn, post) do
  	[
      post.title, 
      img_tag(Artour.ImageView.url_for(post.cover_image, :thumbnail), class: "thumbnail-sm", loading: "lazy"),
      link(post.slug, to: Artour.PublicPostView.show_path(conn, post), class: publication_date_index_cell_class(post.is_published)), 
      content_tag(:div, is_nsfw_index_cell_content(post.is_nsfw), class: is_nsfw_index_cell_class(post.is_nsfw)),
      content_tag(:div, Common.DateHelpers.us_formatted_date(post.publication_date), class: publication_date_index_cell_class(post.is_published)), 
    ]
  end

  @doc """
  Returns css class for index table cell
  """
  def publication_date_index_cell_class(is_published) do
    case is_published do
      true  -> ""
      false -> "alert-warning"
    end
  end

  @doc """
  Returns css class for index table cell
  """
  def is_nsfw_index_cell_class(is_nsfw) do
    case is_nsfw do
      true  -> "alert-danger"
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
  Used on show page - takes post instance and returns list of 
  formatted values
  """
  def attributes(conn, post) do
    show_url = Artour.PublicPostView.show_path(conn, post)
    api_images_url = api_post_path(conn, :post_images, post.id, export: "true")

    [
      {"Title", post.title}, 
      {"Public Url", link(show_url, to: show_url)}, 
      {"Export Url", link(api_images_url, to: api_images_url)}, 
      {"Publication Date", Common.DateHelpers.us_formatted_date(post.publication_date)}, 
      {"NSFW", post.is_nsfw}, 
      {"Markdown", post.is_markdown}, 
      {"Published", post.is_published}, 
      {"Body", Artour.PublicPostView.formatted_post_body(post.body, post.is_markdown)},
    ]
  end
end
