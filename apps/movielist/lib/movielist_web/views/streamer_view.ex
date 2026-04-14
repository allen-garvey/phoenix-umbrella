defmodule MovielistWeb.StreamerView do
  use MovielistWeb, :view

  def to_s(nil) do
    ""
  end

  def to_s(streamer) do
    streamer.name
  end

  def show_link(streamer) do
    case streamer do
      nil -> nil
      _ -> link(to_s(streamer), to: ~p"/streamers/#{streamer}")
    end
  end

  Common.ViewHelpers.Form.define_map_for_form()
end
