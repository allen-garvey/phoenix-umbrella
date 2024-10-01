defmodule Common.SuperSearch do
	def base_url do
		Application.fetch_env!(:common, :super_search_url)
	end

	def search_url(query) do
		cleaned_query = URI.encode_query(%{"q" => query}, :rfc3986)
		"#{base_url()}/?#{cleaned_query}"
	end

	def direct_search_url(library_key, query) do
		"#{base_url()}/#{library_key}/#{query}"
			|> URI.encode
	end
end
