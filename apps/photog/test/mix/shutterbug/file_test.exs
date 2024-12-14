defmodule Photog.Shutterbug.FileTest do
  use PhotogWeb.DefaultCase

  alias Photog.Shutterbug.File

  test "get_directory_prefix_map" do
    directory_prefix_map =
      ["b/test.jpg", "something.webp", "a/test.jpg", "HELLO/aoeu/test.jpg", "hello/aoeu/test.jpg"]
      |> File.get_directory_prefix_map()

    assert directory_prefix_map == %{
             "." => "1",
             "HELLO/aoeu" => "2",
             "a" => "3",
             "b" => "4",
             "hello/aoeu" => "5"
           }
  end

  test "get_directory_prefix_map with double digits" do
    directory_prefix_map =
      ?a..?z
      |> Enum.map(fn digit -> "#{to_string([digit])}/test.webp" end)
      |> File.get_directory_prefix_map()

    assert directory_prefix_map == %{
             "a" => "01",
             "b" => "02",
             "c" => "03",
             "d" => "04",
             "e" => "05",
             "f" => "06",
             "g" => "07",
             "h" => "08",
             "i" => "09",
             "j" => "10",
             "k" => "11",
             "l" => "12",
             "m" => "13",
             "n" => "14",
             "o" => "15",
             "p" => "16",
             "q" => "17",
             "r" => "18",
             "s" => "19",
             "t" => "20",
             "u" => "21",
             "v" => "22",
             "w" => "23",
             "x" => "24",
             "y" => "25",
             "z" => "26"
           }
  end

  test "add_prefix_to_file" do
    directory_prefix_map = Map.new([{"something/hello", "045"}])

    assert File.add_prefix_to_file(directory_prefix_map, "something/hello/test.png") ==
             "045_test.png"
  end

  test "file_path_with_prefix" do
    directory_prefix_map = Map.new([{"test", "01"}])

    assert File.file_path_with_prefix(directory_prefix_map, "test/hello.jpg", "path/to/masters") ==
             "path/to/masters/01_hello.jpg"
  end
end
