defmodule StartpageWeb.FolderViewTest do
  use StartpageWeb.ConnCase, async: true
  use StartpageWeb, :view
  require Assertions

  alias StartpageWeb.FolderView

  def compare_tags(tag1, tag2) do
    safe_to_string(tag1) == safe_to_string(tag2)
  end

  test "Parses folder content" do
    folder_content_list = FolderView.content_to_list("""
    google.com --- google
    ====
    //test${UMBRELLA_DOMAIN} --- Umbrella test
    """)
    expected_content_list = [
                              content_tag(:a, "google", href: "google.com"),
                              tag(:hr),
                              content_tag(:a, "Umbrella test", href: "//test#{Common.Endpoint.cookie_domain()}"),
                            ]
    Assertions.assert_lists_equal(folder_content_list, expected_content_list, &compare_tags/2)
  end


end
