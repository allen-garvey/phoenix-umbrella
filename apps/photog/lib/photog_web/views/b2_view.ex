defmodule PhotogWeb.B2View do
    use PhotogWeb, :view

    def render("download_token.json", %{download_token_response: download_token_response}) do
        %{data: 
            %{
                download_url: download_token_response.download_url,
                download_token: download_token_response.download_token,
            }
        }
    end
end
  