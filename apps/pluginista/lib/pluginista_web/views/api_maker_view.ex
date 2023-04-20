defmodule PluginistaWeb.ApiMakerView do
    use PluginistaWeb, :view

    def render("index.json", %{conn: conn, makers: makers}) do
        %{
            data: Map.new(Stream.with_index(makers), fn {maker, index} -> 
                {
                    maker.id,
                    %{
                        id: maker.id,
                        sort: index,
                        name: maker.name,
                        url: Routes.maker_path(conn, :show, maker),
                    }
                }
            end)
        }
    end
  
end
  