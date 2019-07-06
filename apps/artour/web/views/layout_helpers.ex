# For code shared across views that relates to whole application
defmodule Artour.LayoutHelpers do
	use Phoenix.HTML

	@doc """
  	Used in title of site, in such places as the title tag
  	"""
	def site_title() do
		"Strange Scenery"	
	end

  def site_title(nil) do
    site_title()
  end

  def site_title(page_title) when is_binary(page_title) do
    site_title() <> " | " <> page_title
  end

  @doc """
    Description of site, used in meta description tag on public pages
    """
  def site_description() do
    "The artwork and photography of Allen Garvey"
  end

	@doc """
  	Takes string and splits by newlines, converts into
  	paragraph tags and returns string of combined paragraphs
  	"""
	def to_paragraphs(text) when is_binary(text) do
    text
      |> String.split("\n")
      # remove empty strings to allow multiple line-breaks in raw text
      |> Enum.filter(&(String.length(&1) > 1))
      |> Enum.map(&(content_tag(:p, &1)))
  end

  def to_paragraphs(_not_string) do
    raw ""
  end

end