defmodule PhotogWeb.B2Controller do
  use PhotogWeb, :controller

  alias Photog.B2.DownloadTokenResponse

  action_fallback(PhotogWeb.FallbackController)
  plug(:put_view, json: PhotogWeb.B2View)

  def download_token(conn, _params) do
    case get_session(conn, :b2_download_token) do
      nil ->
        download_new_token(conn)

      download_token_response ->
        case DateTime.compare(DateTime.utc_now(), download_token_response.expiration_time) do
          :lt ->
            render(conn, "download_token.json", download_token_response: download_token_response)

          _ ->
            download_new_token(conn)
        end
    end
  end

  defp download_new_token(conn) do
    case fetch_token() do
      {:ok, download_token_response} ->
        put_session(conn, :b2_download_token, download_token_response)
        |> render("download_token.json", download_token_response: download_token_response)

      {:error, message} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(CommonWeb.ApiGenericView)
        |> render("error.json", message: message)
    end
  end

  defp fetch_token() do
    with {:ok, b2_key} <- Application.fetch_env(:photog, :b2_application_key),
      {:ok, response} <- b2_authorize_account(b2_key),
      {:ok, download_token_response} <- to_download_token_response(response.body),
      {:ok, download_authorization_response} <- b2_get_download_authorization(download_token_response) do
        response = %DownloadTokenResponse{
          download_token_response | download_token: download_authorization_response.body["authorizationToken"]
        }
        {:ok, response}
    else
      :error -> {:error, "B2 Key not set"}
      error -> error
    end
  end

  defp b2_authorize_account(b2_application_key) do
    Req.get(
      url: "https://api.backblazeb2.com/b2api/v3/b2_authorize_account",
      headers: [
        content_type: "application/json",
        # for some reason using the :auth option doesn't work, so need to send header directly
        authorization: "Basic #{b2_application_key}"
      ]
    )
  end

  defp b2_get_download_authorization(download_token_response) do
    Req.post(
      url: "#{download_token_response.api_url}/b2api/v3/b2_get_download_authorization",
      headers: [
        content_type: "application/json",
        # for some reason using the :auth option doesn't work, so need to send header directly
        authorization: download_token_response.authorization_token,
      ],
      json: %{
        validDurationInSeconds: 900,
        fileNamePrefix: download_token_response.file_name_prefix,
        bucketId: download_token_response.bucket_id
      }
    )
  end

  defp to_download_token_response(json) do
    storage_api = json["apiInfo"]["storageApi"]

    download_token_response = %DownloadTokenResponse{
      api_url: storage_api["apiUrl"],
      download_url: storage_api["downloadUrl"],
      authorization_token: json["authorizationToken"],
      bucket_id: storage_api["bucketId"],
      file_name_prefix: storage_api["namePrefix"],
      expiration_time: DateTime.utc_now() |> DateTime.add(800, :second)
    }

    {:ok, download_token_response}
  end
end
