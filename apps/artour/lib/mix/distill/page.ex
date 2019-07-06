defmodule Distill.Page do
	alias Distill.PageRoute
	@doc """
	Returns a list of page routes for page controller
	"""
	def routes() do
		[
	  		%PageRoute{path: "/", controller: Artour.PageController, handler: :index},
	  		%PageRoute{path: "/pages", controller: Artour.PageController, handler: :pagination_index},
	  		%PageRoute{path: "/404.html", controller: Artour.PageController, handler: :error_404},
	  		%PageRoute{path: "/about", controller: Artour.PageController, handler: :about},
	  		%PageRoute{path: "/browse", controller: Artour.PageController, handler: :browse},
	  		%PageRoute{path: "/posts", controller: Artour.PublicPostController, handler: :index},
	  		%PageRoute{path: "/categories", controller: Artour.PublicCategoryController, handler: :index},
	  		%PageRoute{path: "/tags", controller: Artour.PublicTagController, handler: :index},
		]
	end

	@doc """
	Returns a list of page routes for paginated index pages
	"""
	def paginated_index_routes(last_page_num) when is_integer(last_page_num) do
		Enum.map 1..last_page_num, &page_route_for/1
	end

	@doc """
	Returns a page route for a given page number for paginated index pages
	"""
	def page_route_for(page_num) when is_integer(page_num) do
		%PageRoute{path: "/pages/" <> Integer.to_string(page_num), controller: Artour.PageController, handler: :page, params: %{"page_num" => page_num}}
	end
end