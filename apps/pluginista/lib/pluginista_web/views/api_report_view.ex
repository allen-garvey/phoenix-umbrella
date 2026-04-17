defmodule PluginistaWeb.ApiReportView do
  use PluginistaWeb, :view

  def render("makers.json", %{makers: makers}) do
    %{
      data:
        Enum.map(makers, fn maker ->
          %{
            id: maker[:id],
            name: maker[:name],
            total: maker[:total],
            count: maker[:count],
            url: ~p"/makers/#{maker[:id]}"
          }
        end)
    }
  end
end
