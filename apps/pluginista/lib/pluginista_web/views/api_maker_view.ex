defmodule PluginistaWeb.ApiMakerView do
  use PluginistaWeb, :view

  def render("index.json", %{makers: makers}) do
    %{
      data:
        Map.new(Stream.with_index(makers), fn {maker, index} ->
          {
            maker.id,
            %{
              id: maker.id,
              sort: index,
              name: maker.name,
              url: ~p"/makers/#{maker}"
            }
          }
        end)
    }
  end
end
