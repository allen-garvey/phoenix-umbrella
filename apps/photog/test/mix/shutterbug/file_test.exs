defmodule Photog.Shutterbug.FileTest do
  use PhotogWeb.DefaultCase

  test "get_directory_prefix_map" do
    directory_prefix_map =
      ["b/test.jpg", "something.webp", "a/test.jpg", "HELLO/aoeu/test.jpg", "hello/aoeu/test.jpg"]
      |> Photog.Shutterbug.File.get_directory_prefix_map()

    assert Enum.count(directory_prefix_map) == 5
    assert Map.get(directory_prefix_map, ".") == "1"
    assert Map.get(directory_prefix_map, "HELLO/aoeu") == "2"
    assert Map.get(directory_prefix_map, "a") == "3"
    assert Map.get(directory_prefix_map, "b") == "4"
    assert Map.get(directory_prefix_map, "hello/aoeu") == "5"
  end

  test "get_directory_prefix_map with double digits" do
    directory_prefix_map =
      ?a..?z
      |> Enum.map(fn digit -> "#{to_string([digit])}/test.webp" end)
      |> Photog.Shutterbug.File.get_directory_prefix_map()

    assert Enum.count(directory_prefix_map) == 26
    assert Map.get(directory_prefix_map, "b") == "02"
  end
end
