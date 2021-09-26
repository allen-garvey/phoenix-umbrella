defmodule MovielistWeb.StreamerView do
  use MovielistWeb, :view

  def to_s(nil) do
  	""
  end

  def to_s(streamer) do
  	streamer.name
  end

  @doc """
  Maps a list of streamers into tuples, used for forms
  """
  def map_for_form(streamers) do
    Enum.map(streamers, &{to_s(&1), &1.id})
  end
end
