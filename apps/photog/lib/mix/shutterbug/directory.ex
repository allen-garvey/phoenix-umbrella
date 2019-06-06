defmodule Photog.Shutterbug.Directory do

  def digit_pad_2(digit) do
		digit
		|> Integer.to_string
		|> String.pad_leading(2, "0")
	end

  @doc """
  Returns the path for the import relative to the Masters or Thumbnails directory
  Import directory format based on what apple photos uses
  """
  def import_relative_path(datetime) do
    year = Integer.to_string(datetime.year)
    month = digit_pad_2(datetime.month)
    day = digit_pad_2(datetime.day)
    hour = digit_pad_2(datetime.hour)
    minute = digit_pad_2(datetime.minute)
    second = digit_pad_2(datetime.second)

    Path.join([
      year,
      month,
      day,
      "#{year}#{month}#{day}-#{hour}#{minute}#{second}"
    ])
  end

  @doc """
  Returns path for image masters for import
  """
  def masters_path(target_directory, datetime) do
    Path.join([
      target_directory,
      import_relative_path(datetime),
    ])
  end

  @doc """
  Returns path for image thumbnails for import
  """
  def thumbnails_path(target_directory, datetime) do
    Path.join([
      target_directory,
      import_relative_path(datetime),
    ])
  end

end
