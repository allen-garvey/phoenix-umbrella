defmodule Photog.Shutterbug.FileTest do
  use PhotogWeb.DefaultCase

  alias Photog.Shutterbug.File

  test "get_directory_prefix_map" do
    directory_prefix_map =
      ["b/test.jpg", "something.webp", "a/test.jpg", "HELLO/aoeu/test.jpg", "hello/aoeu/test.jpg"]
      |> File.get_directory_prefix_map()

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
      |> File.get_directory_prefix_map()

    assert Enum.count(directory_prefix_map) == 26
    assert Map.get(directory_prefix_map, "b") == "02"
  end

  test "get_image_master_action_for() without webp option" do
    assert File.get_image_master_action_for("test/hello.jpg", false) == :safe_copy
    assert File.get_image_master_action_for("test/hello.svg", false) == :safe_copy
    assert File.get_image_master_action_for("test/hello.png", false) == :convert_to_webp_lossless
    assert File.get_image_master_action_for("test/hello.webp", false) == :safe_copy
    assert File.get_image_master_action_for("test/hello.heic", false) == :convert_to_webp_lossy
    assert File.get_image_master_action_for("test/hello.tiff", false) == :safe_copy
  end

  test "get_image_master_action_for() using webp option" do
    assert File.get_image_master_action_for("test/hello.jpg", true) == :convert_to_webp_lossy
    assert File.get_image_master_action_for("test/hello.svg", true) == :safe_copy
    assert File.get_image_master_action_for("test/hello.png", true) == :convert_to_webp_lossless
    assert File.get_image_master_action_for("test/hello.webp", true) == :safe_copy
    assert File.get_image_master_action_for("test/hello.heic", true) == :convert_to_webp_lossy
    assert File.get_image_master_action_for("test/hello.tiff", true) == :convert_to_webp_lossy
  end
end
