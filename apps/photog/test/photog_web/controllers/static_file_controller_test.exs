defmodule PhotogWeb.StaticFileControllerTest do
  use PhotogWeb.DefaultCase
  alias PhotogWeb.StaticFileController

  test "safe_path_join() with invalid values" do
    assert StaticFileController.safe_path_join(["..", "something"], "/test") ==
             :error

    assert StaticFileController.safe_path_join(["..", "..", "something"], "/test") ==
             :error

    assert StaticFileController.safe_path_join(["something", "..", ".."], "/test") ==
             :error
  end

  test "safe_path_join() with values" do
    assert StaticFileController.safe_path_join(["..", "..", "something"], "/") ==
             {:ok, "/something"}

    assert StaticFileController.safe_path_join(["something", ".."], "/test") ==
             {:ok, "/test"}

    assert StaticFileController.safe_path_join(["something", "..", "..", "test"], "/test") ==
             {:ok, "/test"}

    assert StaticFileController.safe_path_join(["something", "..", "another"], "/test") ==
             {:ok, "/test/another"}
  end
end
