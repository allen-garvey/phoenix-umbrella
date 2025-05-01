defmodule Photog.Image.Exif do
  alias Photog.Api.Image

  @doc """
  Gets a the exif data from an image's master image using exiftool
  https://stackoverflow.com/questions/26654709/extract-exif-data-as-text-using-imagemagick
  requires the `exiftool` command from libimage-exiftool-perl
  `# exiftool -duplicates -unknown -tab image.jpg`
  """
  def exif_for(%Image{} = image) do
    Photog.Image.master_file_path(image)
    |> Common.ImageHelpers.Exif.exif_for()
  end

  @doc """
  Gets creation datetime string for an image from exif_map returned from exif_for/1
  example return is:
  "2010:08:29 15:44:22"
  """
  def exif_creation_time(exif_map) do
    exif_map["CreateDate"] || exif_map["FileModifyDate"]
  end

  @doc """
  Looks at file path, if it matches YYYY-MM-DD pattern at the start returns datetime, otherwise returns nil
  """
  def file_path_to_datetime(file_path) when is_binary(file_path) do
    case Regex.match?(~r/^[12]\d{3}-[01]\d-[0123]\d\D/, file_path) do
      true ->
        String.slice(file_path, 0..9)
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
        |> file_split_to_datetime()

      false ->
        {:error, :no_date_found_in_path}
    end
  end

  defp file_split_to_datetime([years, months, days]) do
    case Date.new(years, months, days) do
      {:ok, date} -> DateTime.new(date, Time.new!(0, 0, 0, 0), "Etc/UTC")
      error -> error
    end
  end

  @doc """
  Gets creation datetime as datetime
  Uses utc timezone as exif does not contain timezone information
  Returns nil if creation date is not in exif map
  retuns {:ok, datetime, calendar_utc_offset_integer} if datetime is valid
  return {:error, :reason} if datetime string is not valid
  """
  def exif_creation_time_as_datetime(exif_map, image_source_path) do
    case [
      creation_time_to_datetime(exif_map["CreateDate"]),
      file_path_to_datetime(image_source_path),
      creation_time_to_datetime(exif_map["FileModifyDate"])
    ] do
      [{:ok, datetime, _}, _, _] -> {:ok, datetime}
      [{:error, reason}, _, _] -> {:error, reason}
      [_, {:ok, datetime}, _] -> {:ok, datetime}
      [_, _, {:ok, datetime, _}] -> {:ok, datetime}
      _ -> nil
    end
  end

  defp creation_time_to_datetime("") do
    nil
  end

  defp creation_time_to_datetime("0000:00:00 00:00:00") do
    nil
  end

  defp creation_time_to_datetime(creation_time) when is_binary(creation_time) do
    datetime_split = Regex.split(~r/[ :-]/, creation_time)

    # sometimes timezone is after seconds
    last_item = Enum.at(datetime_split, 5)

    {seconds, timezone} =
      case String.length(last_item) do
        # no timezone, so just use utc
        2 -> {last_item, "Z"}
        _ -> {String.slice(last_item, 0..1), String.slice(last_item, 2..7)}
      end

    "#{Enum.at(datetime_split, 0)}-#{Enum.at(datetime_split, 1)}-#{Enum.at(datetime_split, 2)}T#{Enum.at(datetime_split, 3)}:#{Enum.at(datetime_split, 4)}:#{seconds}#{timezone}"
    |> DateTime.from_iso8601()
  end

  defp creation_time_to_datetime(_creation_time) do
    nil
  end
end
