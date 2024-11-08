defmodule Artour.ImageView do
  use Artour.Web, :view

  @doc """
  How single image instance should be represented in views
  """
  def display_name(image) do
    image.title
  end

  @doc """
  Renders page to create new image
  """
  def render("new.html", assigns) do
    assigns = Map.merge(assigns, %{action: image_path(assigns[:conn], :create),
                                   heading: Artour.SharedView.form_heading("image", :new),
                                   save_another: true})

    render "form_page.html", assigns
  end

  @doc """
  Renders page to edit image
  """
  def render("edit.html", assigns) do
    assigns = Map.merge(assigns, %{action: image_path(assigns[:conn], :update, assigns[:image]),
                                   heading: Artour.SharedView.form_heading(display_name(assigns[:image]), :edit),
                                   show_delete: true})

    render "form_page.html", assigns
  end

  @doc """
  Generates the contents of HTML img tag srcset attribute
  for a given image instance
  assumes that image.filename_small is used as src attribute
  doesn't use large url, because assumes image is in container
  """
  def srcset_for(image) do
    "#{url_for(image, :small)} 400w, #{url_for(image, :medium)} 800w"
  end

  @doc """
  Generates the contents of HTML img tag srcset attribute
  for a given image instance
  assumes that image.filename_small is used as src attribute
  used for when image is being shown fullsize 
  (not in a container, such as in an album)
  """
  def srcset_for_fullsize(image) do
    "#{srcset_for(image)}, #{url_for(image, :large)} 1000w"
  end

  @doc """
  Returns HTML img tag for a given image instance
  lazy loaded version of img_tag_for/3
  src is set to the small source file, and srcset is used for other sizes
  """
  def lazy_img_tag_for(image) do
    tag(:img,
        data:
          [
            src: url_for(image, :small),
            srcset: srcset_for(image)
          ],
          alt: image.description,
          class: "lazy-image-placeholder"
        )
  end

  @doc """
  Returns HTML img tag for a given image instance
  src is set to the small source file, and srcset is used for other sizes
  """
  def img_tag_for(image) do
    img_tag(url_for(image, :small), alt: image.description, srcset: srcset_for(image), loading: "lazy")
  end

  @doc """
  Returns HTML img tag for a given image instance
  size: atom should be the same as for url_for
  """
  def img_tag_for(image, size) do
    img_tag(url_for(image, size), alt: image.description, loading: "lazy")
  end

  @doc """
  Returns image filename for given size
  """
  def filename_for_size(image, size) do
    case size do
      :large -> image.filename_large
      :medium -> image.filename_medium
      :small -> image.filename_small
      :thumbnail -> image.filename_thumbnail
    end
  end

  @doc """
  Returns url for image
  """
  def url_for(image, size) do
    URI.encode("/media/images/" <> filename_for_size(image, size))
  end

  @doc """
  Used on index page - returns abbreviated list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names_short() do
    ["Title", "Thumbnail", "Description", "Year"]
  end

  @doc """
  Used on index page - takes image instance and returns abbreviated list of 
  formatted values
  """
  def attribute_values_short(_conn, image) do
  	[image.title, img_tag(url_for(image, :thumbnail), class: "thumbnail", loading: "lazy"), image.description, image.year]
  end

  @doc """
  Used on show page - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    ["Title", "Description", "Filename Large", "Filename Medium", "Filename Small", "Filename Thumbnail", "Date Completed", "Year"]
  end

  @doc """
  Used on show page - takes image instance and returns list of 
  formatted values
  """
  def attribute_values(image) do
    [image.title, image.description, image.filename_large, image.filename_medium, image.filename_small, image.filename_thumbnail, Artour.DateHelpers.date_to_us_date(image.completion_date), image.year]
  end
end
