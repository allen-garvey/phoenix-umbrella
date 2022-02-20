defmodule Distill.Page do
	alias Distill.PageRoute
	@doc """
	Returns a list of page routes for page controller
	"""
	def routes() do
		[
	  		%PageRoute{path: "/", controller: Artour.PageController, handler: :index},
	  		%PageRoute{path: "/404.html", controller: Artour.PageController, handler: :error_404},
		]
	end
	
end