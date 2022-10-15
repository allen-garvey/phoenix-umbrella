defmodule PluginistaWeb.GroupView do
  use PluginistaWeb, :view

  def to_s(group) do
  	group.name
  end

  @doc """
  Maps a list of groups into tuples, used for forms
  """
  def map_for_form(groups) do
    Enum.map(groups, &{to_s(&1), &1.id})
  end
end
