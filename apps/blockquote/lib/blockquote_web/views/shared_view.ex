defmodule BlockquoteWeb.SharedView do
  use BlockquoteWeb, :view

	defp item_path_func_name(item_name_singular) do
		String.to_atom(String.replace(item_name_singular, " ", "_") <> "_path")
	end

	@doc """
  	Returns path for item
  	(e.g. :index, :show, :new)
  	"""
	def path_for_item(conn, item_name_singular, path_atom) do
		apply(BlockquoteWeb.Router.Helpers, item_path_func_name(item_name_singular), [conn, path_atom])
	end

	@doc """
  	Returns path for item instance
  	(e.g. :edit and :show)
  	"""
	def path_for_item(conn, item_name_singular, path_atom, item_instance) do
		apply(BlockquoteWeb.Router.Helpers, item_path_func_name(item_name_singular), [conn, path_atom, item_instance])
	end

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

	def breadcrumb_link(conn, item_name_singular) do
		link_title = item_name_singular |> Common.StringHelpers.naive_pluralize |> String.capitalize

		link link_title, to: path_for_item(conn, item_name_singular, :index)
	end
end
