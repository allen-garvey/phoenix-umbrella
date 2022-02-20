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
  def srcset_for(conn, image, location) do
    "#{url_for(conn, image, :small, location)} 400w, #{url_for(conn, image, :medium, location)} 800w"
  end

  @doc """
  Generates the contents of HTML img tag srcset attribute
  for a given image instance
  assumes that image.filename_small is used as src attribute
  used for when image is being shown fullsize 
  (not in a container, such as in an album)
  """
  def srcset_for_fullsize(conn, image, location) do
    "#{srcset_for(conn, image, location)}, #{url_for(conn, image, :large, location)} 1000w"
  end

  @doc """
  Returns HTML img tag for a given image instance
  lazy loaded version of img_tag_for/3
  src is set to the small source file, and srcset is used for other sizes
  location: atom that should be either :cloud or :local
  """
  def lazy_img_tag_for(conn, image, location) do
    tag(:img,
        data:
          [
            src: url_for(conn, image, :small, location),
            srcset: srcset_for(conn, image, location)
          ],
          alt: image.description,
          class: "lazy-image-placeholder"
        )
  end

  @doc """
  Returns HTML img tag for a given image instance
  src is set to the small source file, and srcset is used for other sizes
  location: atom that should be either :cloud or :local
  """
  def img_tag_for(conn, image, location) do
    img_tag(url_for(conn, image, :small, location), alt: image.description, srcset: srcset_for(conn, image, location), loading: "lazy")
  end

  @doc """
  Returns HTML img tag for a given image instance
  size: atom should be the same as for url_for
  location: atom that should be either :cloud or :local
  """
  def img_tag_for(conn, image, size, location) do
    img_tag(url_for(conn, image, size, location), alt: image.description, loading: "lazy")
  end

  @doc """
  Returns base url for location
  location is local (admin) or cloud (potentially b2 on s3)
  """
  def base_url_for(location_atom) do
    case location_atom do
      :local -> "/media/images/"
      :cloud -> "/media/images/"
    end
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
  size is atom representing image size
  location is either :cloud (public) or :local (admin)
  """
  def url_for(conn, image, size, location) do
    image_url = URI.encode(base_url_for(location) <> filename_for_size(image, size))
    static_path(conn, image_url)
  end

  @doc """
  Used on index page - returns abbreviated list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names_short() do
    ["Title", "Thumbnail", "Description", "Format", "Date Completed"]
  end

  @doc """
  Used on index page - takes image instance and returns abbreviated list of 
  formatted values
  """
  def attribute_values_short(conn, image) do
  	[image.title, img_tag(url_for(conn, image, :thumbnail, :local), class: "thumbnail", loading: "lazy"), image.description, Artour.FormatView.display_name(image.format), Artour.DateHelpers.date_to_us_date(image.completion_date)]
  end

  @doc """
  Used on show page - returns list of attribute names in the
  same order as the attribute_values function
  """
  def attribute_names() do
    ["Title", "Slug", "Description", "Filename Large", "Filename Medium", "Filename Small", "Filename Thumbnail", "Format", "Date Completed"]
  end

  @doc """
  Used on show page - takes image instance and returns list of 
  formatted values
  """
  def attribute_values(image) do
    [image.title, image.slug, image.description, image.filename_large, image.filename_medium, image.filename_small, image.filename_thumbnail, Artour.FormatView.display_name(image.format), Artour.DateHelpers.date_to_us_date(image.completion_date)]
  end
end
