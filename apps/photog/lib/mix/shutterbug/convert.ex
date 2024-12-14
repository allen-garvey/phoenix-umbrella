defmodule Photog.Shutterbug.Convert do
  alias Common.MixHelpers.Error

  @doc """
  Takes image at source path and converts to webp lossless at destination path. image_destination_path should already have .webp file extension.
  """
  def to_webp_lossless(image_source_path, image_destination_path) do
    with {_, 0} <-
           System.cmd("convert", [
             image_source_path,
             "-define",
             "webp:lossless=true",
             "-auto-orient",
             image_destination_path
           ]) do
      # file permissions should be correct (tested with convert command and permissions are +r) but set permissions just in case
      File.chmod!(image_destination_path, 0o644)
    else
      _ ->
        Error.exit_with_error(
          "Error converting #{image_source_path} to #{image_destination_path} using convert",
          :error_converting_to_webp_lossless
        )
    end
  end

  @doc """
  Takes image at source path and converts to webp lossy at destination path. image_destination_path should already have .webp file extension.

  """
  def to_webp_lossy(image_source_path, image_destination_path) do
    with {_, 0} <-
           System.cmd("convert", [
             image_source_path,
             "-quality",
             "85%",
             "-auto-orient",
             image_destination_path
           ]) do
      # file permissions should be correct (tested with convert command and permissions are +r) but set permissions just in case
      File.chmod!(image_destination_path, 0o644)
    else
      _ ->
        Error.exit_with_error(
          "Error converting #{image_source_path} to #{image_destination_path} using convert",
          :error_converting_to_webp_lossless
        )
    end
  end

  @doc """
  Resizes image to given dimension on shortest side using imagemagick
  Resize on largest side from: https://www.imagemagick.org/discourse-server/viewtopic.php?t=13175
  """
  def resize_image(image_source_path, image_destination_path, size) when is_integer(size) do
    with {_, 0} <-
           System.cmd("convert", [
             image_source_path,
             "-resize",
             "#{size}^>",
             "-quality",
             "75%",
             "-auto-orient",
             image_destination_path
           ]) do
      # file permissions should be correct (tested with convert command and permissions are +r) but set permissions just in case
      File.chmod!(image_destination_path, 0o644)
    else
      _ ->
        Error.exit_with_error(
          "Error converting #{image_source_path} to #{image_destination_path} using convert",
          :error_creating_thumbnail
        )
    end
  end
end
