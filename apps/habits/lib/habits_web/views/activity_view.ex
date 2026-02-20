defmodule HabitsWeb.ActivityView do
  alias HabitsWeb.CategoryView
  use HabitsWeb, :view

  defp url_to_link([text, url]) do
    [text, link(url, to: url, target: "_blank", rel: "noopener noreferrer")]
  end

  defp url_to_link(other) do
    other
  end

  def linkify_description(description) when is_binary(description) do
    url_regex = ~r/\bhttps?:\/\/\S+/

    Regex.split(url_regex, description, include_captures: true)
    |> Enum.chunk_every(2)
    |> Enum.flat_map(&url_to_link/1)
  end

  def linkify_description(description) do
    description
  end

  def get_category_id(%Ecto.Changeset{} = changeset) do
    case Ecto.Changeset.get_field(changeset, :tag, nil) do
      nil -> nil
      tag -> tag.category_id
    end
  end
end
