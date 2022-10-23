defmodule BooklistWeb.SharedView do
  use BooklistWeb, :view
  
  def submit_button(resource_title) do
	content_tag(:div, submit("Save " <> resource_title, class: "btn btn-success"))	
  end
end
