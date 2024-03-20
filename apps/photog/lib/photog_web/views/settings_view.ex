defmodule PhotogWeb.SettingsView do
    use PhotogWeb, :view
  
    def render("index.json", %{image_url_prefix: image_url_prefix}) do
        %{ data: 
            %{
                image_url_prefix: image_url_prefix,
            }
        }
    end
end
  