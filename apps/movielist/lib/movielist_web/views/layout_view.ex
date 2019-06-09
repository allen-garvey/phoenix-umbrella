defmodule MovielistWeb.LayoutView do
  use MovielistWeb, :view

  @doc """
  Returns css class for navigation pill if current page
  """
  def active_nav_class(nil, _page_atom) do
  	nil
  end
  def active_nav_class(current_page_atom, page_atom) do
  	if current_page_atom == page_atom do
  		"active"
  	else
  		nil
  	end
  end
end
