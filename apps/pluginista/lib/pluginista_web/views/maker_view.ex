defmodule PluginistaWeb.MakerView do
  use PluginistaWeb, :view

  def to_s(maker) do
  	maker.name
  end

  @doc """
  Maps a list of makers into tuples, used for forms
  """
  def map_for_form(makers) do
    Enum.map(makers, &{to_s(&1), &1.id})
  end
end
