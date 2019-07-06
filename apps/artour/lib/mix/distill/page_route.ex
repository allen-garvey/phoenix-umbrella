defmodule Distill.PageRoute do
	@doc """
  Used in distill.html mix task
  Represents a html route
  path - string - root relative url
  controller - atom - controller for route
  handler - atom - function on controller to be called
  params - hash (optional) - params to be passed to handler
  """
	@enforce_keys [:path, :controller, :handler]
	defstruct path: "", controller: nil, handler: nil, params: %{}
end