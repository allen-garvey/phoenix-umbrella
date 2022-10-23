defmodule MovielistWeb.SharedView do
  use MovielistWeb, :view

  def submit_button(resource_title) do
    content_tag(:div, submit("Save " <> resource_title, class: "btn btn-success"))
  end
end
