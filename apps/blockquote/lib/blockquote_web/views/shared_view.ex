defmodule BlockquoteWeb.SharedView do
  use BlockquoteWeb, :view

	@doc """
  	Returns inserted_at date as string for ecto model
  	"""
  	def item_date_created(item) do
		NaiveDateTime.to_iso8601(item.inserted_at) |> String.replace("T", " ", global: false)
  	end
  	
	@doc """
  	Used to turn a url that might be nil into a link
  	"""
  	def linkify(nil) do
  		nil
  	end

  	def linkify(url) do
  		link(url, to: url)
  	end

	def breadcrumb_link({breadcrumb_title, breadcrumb_path}) do
		link(breadcrumb_title, to: breadcrumb_path)
	end
end
