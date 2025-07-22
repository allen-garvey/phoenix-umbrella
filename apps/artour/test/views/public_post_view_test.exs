defmodule Artour.PublicPostViewTest do
  use Artour.DefaultCase

  alias Artour.PublicPostView

  test "expand_markdown_links() with no link text" do
    assert PublicPostView.expand_markdown_links("") == ""
    assert PublicPostView.expand_markdown_links("Hello") == "Hello"

    assert PublicPostView.expand_markdown_links(
             "A post with [] and () and [bracket stuff] and (parenthesis)"
           ) ==
             "A post with [] and () and [bracket stuff] and (parenthesis)"
  end

  test "expand_markdown_links() with link text" do
    assert PublicPostView.expand_markdown_links("Some text [hello](https://www.google.com).") ==
             "Some text <a href=\"https://www.google.com\">hello</a>."
  end
end
