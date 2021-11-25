defmodule Bookmarker.ApiBookmarkTagView do
  use Bookmarker.Web, :view
  alias Bookmarker.ApiBookmarkTagView
  alias Bookmarker.ApiTagView

  def render("show.json", %{bookmark_tag: bookmark_tag}) do
    %{
      data: render_one(bookmark_tag, ApiBookmarkTagView, "bookmark_tag_excerpt.json")
    }
  end

  @doc """
  Returns error response when
  invalid params for creating bookmark_tag
  http://jsonapi.org/ json api v1.0 format specification
  """
  def render("error.json", %{error: error}) do
    %{
      errors: [error]
    }
  end

  @doc """
  Returns error response when creating bookmark_tag fails
  http://jsonapi.org/ json api v1.0 format specification
  """
  def render("create_error.json", %{errors: errors}) do
    %{
      errors: changeset_errors_to_json(errors)
    }
  end

  # has to be api_bookmark_tag for render_one to work
  def render("bookmark_tag_excerpt.json", %{api_bookmark_tag: bookmark_tag}) do
    %{
      id: bookmark_tag.id,
      bookmark_id: bookmark_tag.bookmark_id,
      tag: ApiTagView.tag_excerpt(bookmark_tag.tag),
    }
  end
  @doc """
  Takes changeset.errors and returns hash
  based on:
  http://www.thisisnotajoke.com/blog/2015/09/serializing-ecto-changeset-errors-to-jsonapi-in-elixir.html
  """
  def changeset_errors_to_json(errors) do
    Enum.map(errors, fn {field, detail} ->
      %{
        title: "Error creating bookmark_tag",
        code: field,
        detail:  to_string(field) <> " " <> to_string( render_detail(detail))
      }
    end)
  end
  @doc """
  Takes error detail hash message and converts to string
  otherwise simply returns string
  http://www.thisisnotajoke.com/blog/2015/09/serializing-ecto-changeset-errors-to-jsonapi-in-elixir.html
  """
  def render_detail({ message, values }) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end
  
  def render_detail(message) do
    message
  end
end
