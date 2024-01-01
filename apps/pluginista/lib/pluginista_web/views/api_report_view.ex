defmodule PluginistaWeb.ApiReportView do
    use PluginistaWeb, :view

    def render("makers.json", %{conn: conn, makers: makers}) do
        %{
            data: Enum.map(makers, fn maker -> 
                %{
                    id: maker[:id],
                    name: maker[:name],
                    total: maker[:total],
                    count: maker[:count],
                    url: Routes.maker_path(conn, :show, maker[:id]),
                }
            end)
        }
    end
end
  