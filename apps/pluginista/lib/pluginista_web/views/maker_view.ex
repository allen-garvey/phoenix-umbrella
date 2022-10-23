defmodule PluginistaWeb.MakerView do
  use PluginistaWeb, :view

  def to_s(maker) do
  	maker.name
  end

  Common.ViewHelpers.Form.define_map_for_form()
end
