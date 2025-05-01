defmodule Photog.Image.ExifTest do
  use PhotogWeb.DefaultCase

  alias Photog.Image.Exif

  test "file_path_to_datetime() with non-date path" do
    assert Exif.file_path_to_datetime("hello.webp") ==
             {:error, :no_date_found_in_path}

    assert Exif.file_path_to_datetime("1-2025-01-01-image.png") ==
             {:error, :no_date_found_in_path}

    assert Exif.file_path_to_datetime("3025-01-01-image.jpg") ==
             {:error, :no_date_found_in_path}

    assert Exif.file_path_to_datetime("2025-31-01-image.webp") ==
             {:error, :no_date_found_in_path}

    assert Exif.file_path_to_datetime("2025-01-41-image.webp") ==
             {:error, :no_date_found_in_path}
  end

  test "file_path_to_datetime() with date path" do
    assert Exif.file_path_to_datetime("2025-01-09-image.png") ==
             {:ok, ~U[2025-01-09 00:00:00.000000Z]}

    assert Exif.file_path_to_datetime("2025-09-28-04-image.png") ==
             {:ok, ~U[2025-09-28 00:00:00.000000Z]}

    assert Exif.file_path_to_datetime("1025-12-31-image-something.png") ==
             {:ok, ~U[1025-12-31 00:00:00.000000Z]}

    assert Exif.file_path_to_datetime("2025-09-28_image.png") ==
             {:ok, ~U[2025-09-28 00:00:00.000000Z]}

    assert Exif.file_path_to_datetime("2025-09-28__image.png") ==
             {:ok, ~U[2025-09-28 00:00:00.000000Z]}
  end

  test "file_path_to_datetime() with date path and invalid date" do
    assert Exif.file_path_to_datetime("2025-02-29-image.png") ==
             {:error, :invalid_date}

    assert Exif.file_path_to_datetime("2025-12-32_image.png") ==
             {:error, :invalid_date}
  end

  test "exif_creation_time_as_datetime() when exif dates are valid" do
    assert Exif.exif_creation_time_as_datetime(
             %{"CreateDate" => "2001:01:01 21:13:31"},
             "something.png"
           ) ==
             {:ok, ~U[2001-01-01 21:13:31Z]}

    assert Exif.exif_creation_time_as_datetime(
             %{"FileModifyDate" => "1999:12:31 22:24:12"},
             "something.png"
           ) ==
             {:ok, ~U[1999-12-31 22:24:12Z]}

    assert Exif.exif_creation_time_as_datetime(
             %{"FileModifyDate" => "1999:12:31 22:24:12"},
             "2024-02-29-image.jpg"
           ) ==
             {:ok, ~U[2024-02-29 00:00:00.000000Z]}

    assert Exif.exif_creation_time_as_datetime(
             %{"CreateDate" => "2001:01:01 21:13:31", "FileModifyDate" => "1999:12:31 22:24:12"},
             "2024-02-29-image.jpg"
           ) ==
             {:ok, ~U[2001-01-01 21:13:31Z]}

    assert Exif.exif_creation_time_as_datetime(
             %{"FileModifyDate" => "1999:12:31 22:24:12"},
             "2024-02-29-image.jpg"
           ) ==
             {:ok, ~U[2024-02-29 00:00:00.000000Z]}
  end

  test "exif_creation_time_as_datetime() when exif dates are invalid" do
    assert Exif.exif_creation_time_as_datetime(
             %{"CreateDate" => "2001:02:29 21:13:31", "FileModifyDate" => "1999:12:31 22:24:12"},
             "2024-02-29-image.jpg"
           ) ==
             {:error, :invalid_date}

    assert Exif.exif_creation_time_as_datetime(
             %{"FileModifyDate" => "1999:02:29 22:24:12"},
             "something.png"
           ) ==
             nil

    assert Exif.exif_creation_time_as_datetime(
             %{},
             "2025-02-29-something.png"
           ) ==
             nil

    assert Exif.exif_creation_time_as_datetime(
             %{"FileModifyDate" => "1999:02:29 22:24:12"},
             "2025-02-29-something.png"
           ) ==
             nil
  end
end
