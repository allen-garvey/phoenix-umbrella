defmodule Artour.PublicPostViewTest do
    use Artour.ConnCase, async: true

    alias Artour.PublicPostView

    test "expand_markdown_links() with empty string" do
        assert PublicPostView.expand_markdown_links("") == ""
      end

    test "expand_markdown_links() with no markdown" do
        s = "Hello (this is an aside) I would like the [4] item"
        assert PublicPostView.expand_markdown_links(s) == s
    end

    test "expand_markdown_links() with markdown links" do
        assert PublicPostView.expand_markdown_links("[Hello](https://google.com/) This is a test of inserting [links](example.com).") == "<a href=\"https://google.com/\">Hello</a> This is a test of inserting <a href=\"example.com\">links</a>."
    end

    test "expand_markdown_links() with html and quotes" do
        assert PublicPostView.expand_markdown_links("A link with [<script>tag</script>](quote.com/\"a)") == "A link with <a href=\"quote.com/&quot;a\"><script>tag</script></a>"
    end
  
 end
  