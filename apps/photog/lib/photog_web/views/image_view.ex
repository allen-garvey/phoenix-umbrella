defmodule PhotogWeb.ImageView do
  use PhotogWeb, :view
  alias PhotogWeb.ImageView
  alias PhotogWeb.DatetimeHelpers
  alias Photog.Image.Exif

  def render("index.json", %{images: images}) do
    %{data: render_many(images, ImageView, "image.json")}
  end

  def render("show.json", %{image: image}) do
    %{data: render_one(image, ImageView, "image.json")}
  end

  def render("show_excerpt_mini.json", %{image: image}) do
    %{data: render_one(image, ImageView, "image_excerpt_mini.json")}
  end

  def render("albums.json", %{albums: albums}) do
    %{data: render_many(albums, PhotogWeb.AlbumView, "album_excerpt_mini.json")}
  end

  def render("persons.json", %{persons: persons}) do
    %{data: render_many(persons, PhotogWeb.PersonView, "person_excerpt_mini.json")}
  end

  def render("image.json", %{image: image}) do
    image_full_to_map(image)
  end

  def render("image_excerpt_mini.json", %{image: image}) do
    %{
      id: image.id,
      is_favorite: image.is_favorite,
    }
  end

  def render("exif.json", %{image: image, exif: exif}) do
    %{data: %{
      image: %{
        id: image.id,
        master_path: image.master_path,
      },
      exif: %{
        camera: %{
          maker: exif["Make"],
          model: exif["Model"],
          model_release_year: exif["ModelReleaseYear"],
          lens_info: exif["LensInfo"],
          lens_model: exif["LensModel"],
        },
        file: %{
          megapixels: exif["Megapixels"],
          creation_time: Exif.exif_creation_time(exif),
          file_type: exif["FileType"],
          mime_type: exif["MIMEType"],
          size: exif["FileSize"],
        },
        image: %{
          dimensions: %{
            width: exif["ImageWidth"],
            height: exif["ImageHeight"],
          },
          aperature: exif["Aperture"],
          shutter: exif["ExposureTime"],
          iso: exif["ISO"],
          orientation: exif["Orientation"],
          camera_mode: exif["ExposureProgram"],
          flash: exif["Flash"],
          focal_length: exif["FocalLength"],
          hdr: exif["HDR"],
          white_balance: exif["WhiteBalance"],
        },
      },
    }}
  end

  def image_to_map(image) do
    %{
      id: image.id,
      creation_time: %{
        raw: image.creation_time,
        formatted: %{
          us_date: DatetimeHelpers.to_us_formatted_date(image.creation_time),
          time: DatetimeHelpers.to_formatted_time(image.creation_time),
        }
      },
      master_path: image.master_path,
      thumbnail_path: image.thumbnail_path,
      mini_thumbnail_path: image.mini_thumbnail_path,
      is_favorite: image.is_favorite,
    }
  end

  def image_thumbnail_to_map(image) do
    %{
      id: image.id,
      mini_thumbnail_path: image.mini_thumbnail_path,
    }
  end

  def image_full_to_map(image) do
    %{
      id: image.id,
      creation_time: %{
        raw: image.creation_time,
        formatted: %{
          us_date: DatetimeHelpers.to_us_formatted_date(image.creation_time),
          time: DatetimeHelpers.to_formatted_time(image.creation_time),
        }
      },
      master_path: image.master_path,
      thumbnail_path: image.thumbnail_path,
      mini_thumbnail_path: image.mini_thumbnail_path,
      is_favorite: image.is_favorite,
      import: PhotogWeb.ImportView.import_excerpt_to_map(image.import),
      albums: Enum.map(image.albums, &PhotogWeb.AlbumView.album_excerpt_mini_to_map/1),
      persons: Enum.map(image.persons, &PhotogWeb.PersonView.person_excerpt_mini_to_map/1),
    }
  end
end
