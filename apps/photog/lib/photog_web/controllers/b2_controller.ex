defmodule PhotogWeb.B2Controller do
    use PhotogWeb, :controller

    alias Photog.B2.DownloadTokenResponse

    action_fallback PhotogWeb.FallbackController

    def download_token(conn, _params) do
        b2_application_key = Application.fetch_env!(:photog, :b2_application_key)
        HTTPoison.start

        result = b2_application_key
        |> validate_application_key
        |> passthrough_error(&b2_authorize_account/1)
        |> passthrough_error(&to_download_token_response/1)
        |> passthrough_error(&b2_get_download_authorization/1)

        case result do
            {:ok, download_token_response} -> render(conn, "download_token.json", download_token_response: download_token_response)
            {:error, message} -> conn |> put_status(:internal_server_error) |> put_view(CommonWeb.ApiGenericView) |> render("error.json", message: message)
        end
    end

    # if there is an error, return the error, otherwise run the transform value
    # state should be either {:error, message} or {:ok, value}\
    # transform function should take the value and return a state
    defp passthrough_error(state, transform) when is_tuple(state) and is_function(transform, 1) do
        case state do
            {:error, _} = error -> error
            {:ok, value} -> transform.(value)
        end
    end

    defp b2_authorize_account(b2_application_key) do
        case HTTPoison.get("https://api.backblazeb2.com/b2api/v3/b2_authorize_account", ["Authorization": "Basic #{b2_application_key}", "Content-Type": "application/json"], []) do
            {:ok, resp} -> case resp.status_code do
                200 -> decode_json(resp.body)
                error_code -> {:error, "Authorize account failed with #{error_code}"}
            end
            {:error, _error} -> {:error, "Could not authorize b2 account."}
        end
    end

    defp b2_get_download_authorization(download_token_response) do
        body = Jason.encode!(%{validDurationInSeconds: 600, fileNamePrefix: download_token_response.file_name_prefix, bucketId: download_token_response.bucket_id})
        
        case HTTPoison.post("#{download_token_response.api_url}/b2api/v3/b2_get_download_authorization", body, ["Authorization": download_token_response.authorization_token, "Content-Type": "application/json"], []) do
            {:ok, resp} -> case resp.status_code do
                200 -> passthrough_error(decode_json(resp.body), fn json -> add_download_token(json, download_token_response) end)
                error_code -> {:error, "Get download authorization failed with #{error_code}"}
            end
            {:error, _error} -> {:error, "Could not get download authorization."}
        end
    end

    defp to_download_token_response(json) do
        storage_api = json["apiInfo"]["storageApi"]

        download_token_response = %DownloadTokenResponse{
            api_url: storage_api["apiUrl"],
            download_url: storage_api["downloadUrl"],
            authorization_token: json["authorizationToken"],
            bucket_id: storage_api["bucketId"],
            file_name_prefix: storage_api["namePrefix"],
        }

        {:ok, download_token_response}
    end

    defp add_download_token(json, download_token_response) do
        updated_download_token_response = %DownloadTokenResponse{download_token_response | download_token: json["authorizationToken"]}

        {:ok, updated_download_token_response}
    end

    defp decode_json(json_string) do
        IO.inspect json_string
        case Jason.decode(json_string) do
            {:ok, _} = success -> success
            {:error, _} -> {:error, "Could not decode JSON."}
        end
    end

    defp validate_application_key(b2_application_key) when is_binary(b2_application_key) do
        case b2_application_key do
            "" -> {:error, "Missing B2 application key"}
            _ -> {:ok, b2_application_key}
        end
    end
end
  