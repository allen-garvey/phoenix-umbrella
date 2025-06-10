defmodule HabitsWeb.ActivityView do
  alias HabitsWeb.CategoryView
  use HabitsWeb, :view

  def linkify_description(description) when is_binary(description) do
    url_regex = ~r/\bhttps?:\/\/\S+/

    # use modified regex in split to increase performance, since we don't need to search the whole string and can just match from the start
    url_split_regex = ~r/^https?:\/\/\S+/

    Regex.split(url_regex, description, include_captures: true)
    |> Enum.map(fn word ->
      case Regex.match?(url_split_regex, word) do
        true -> link(word, to: word, target: "_blank", rel: "noopener noreferrer")
        false -> word
      end
    end)
  end

  def linkify_description(description) do
    description
  end
end
