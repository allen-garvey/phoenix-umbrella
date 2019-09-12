defmodule Common.SuperSearch do
	def base_url do
		Application.fetch_env!(:common, :super_search_url)
	end

	def search_url(query) do
		"#{base_url()}/?q=#{query}"
			|> URI.encode
	end

	def direct_search_url(library_key, query) do
		"#{base_url()}/#{library_key}/#{query}"
			|> URI.encode
	end
end
