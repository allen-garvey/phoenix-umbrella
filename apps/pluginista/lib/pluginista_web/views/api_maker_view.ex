defmodule PluginistaWeb.ApiMakerView do
    use PluginistaWeb, :view

    def render("index.json", %{conn: conn, makers: makers}) do
        %{
            data: Map.new(makers, fn maker -> 
                {
                    maker.id,
                    %{
                        id: maker.id,
                        name: maker.name,
                        url: Routes.maker_path(conn, :show, maker),
                    }
                }
            end)
        }
    end
  
end
  