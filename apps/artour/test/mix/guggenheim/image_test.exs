defmodule Artour.Guggenheim.ImageTest do
  use Artour.DefaultCase

  alias Artour.Guggenheim.Image

  test "get_image_year() with year in directory name" do
    assert Image.get_image_year("/home/2025-images/2024-images/", 2000) == 2024

    assert Image.get_image_year("/home/2025-images/1999-images/", 2000) == 1999

    assert Image.get_image_year("/home/2025-images/2023/", 2000) == 2023
  end

  test "get_image_year() with no year in directory name" do
    assert Image.get_image_year("/home/images/", 2000) == 2000

    assert Image.get_image_year("/home/images/1-images", 2000) == 2000

    assert Image.get_image_year("/home/images/20-images", 2000) == 2000

    assert Image.get_image_year("/home/images/200-images", 2000) == 2000

    assert Image.get_image_year("/home/images/20241-images", 2000) == 2000
  end
end
