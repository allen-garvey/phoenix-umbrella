defmodule MovielistWeb.StreamerView do
  use MovielistWeb, :view

  def to_s(nil) do
  	""
  end

  def to_s(streamer) do
  	streamer.name
  end

  Common.ViewHelpers.Form.define_map_for_form()
end
