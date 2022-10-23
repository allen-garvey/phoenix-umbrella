defmodule PluginistaWeb.GroupView do
  use PluginistaWeb, :view

  def to_s(group) do
  	group.name
  end

  Common.ViewHelpers.Form.define_map_for_form()
end
