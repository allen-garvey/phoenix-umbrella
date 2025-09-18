defmodule PhotogWeb.B2Controller do
  use PhotogWeb, :controller

  alias Photog.B2.DownloadTokenResponse

  action_fallback(PhotogWeb.FallbackController)

  def download_token(conn, _params) do
    case get_session(conn, :b2_download_token) do
      nil ->
        download_new_token(conn)

      download_token_response ->
        cond do
          monotonic_time() -
            download_token_response.time_requested < 800 ->
            render(conn, "download_token.json", download_token_response: download_token_response)

          true ->
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
    HTTPoison.start()

    Application.fetch_env!(:photog, :b2_application_key)
    |> validate_application_key
    |> passthrough_error(&b2_authorize_account/1)
    |> passthrough_error(&to_download_token_response/1)
    |> passthrough_error(&b2_get_download_authorization/1)
  end

  # if there is an error, return the error, otherwise run the transform value
  # state should be either {:error, message} or {:ok, value}
  # transform function should take the value and return a state
  defp passthrough_error(state, transform) when is_tuple(state) and is_function(transform, 1) do
    case state do
      {:error, _} = error -> error
      {:ok, value} -> transform.(value)
    end
  end

  # http_result is result from HTTPoison.get or HTTPoison.post
  # caller is string with calling function name
  # json_consumer is a function/1 that uses result of jason decode call
  defp process_http_result_json(http_result, caller, json_consumer \\ &Function.identity/1)
       when is_tuple(http_result) and is_binary(caller) and is_function(json_consumer, 1) do
    case http_result do
      {:ok, resp} ->
        case resp.status_code do
          200 -> decode_json(resp.body, caller) |> json_consumer.()
          error_code -> {:error, "HTTP request for #{caller} failed with #{error_code}"}
        end

      {:error, _error} ->
        {:error, "There was an error when performing HTTP request for #{caller}."}
    end
  end

  defp b2_authorize_account(b2_application_key) do
    HTTPoison.get(
      "https://api.backblazeb2.com/b2api/v3/b2_authorize_account",
      [Authorization: "Basic #{b2_application_key}", "Content-Type": "application/json"],
      []
    )
    |> process_http_result_json("b2_authorize_account")
  end

  defp b2_get_download_authorization(download_token_response) do
    body =
      Jason.encode!(%{
        validDurationInSeconds: 900,
        fileNamePrefix: download_token_response.file_name_prefix,
        bucketId: download_token_response.bucket_id
      })

    HTTPoison.post(
      "#{download_token_response.api_url}/b2api/v3/b2_get_download_authorization",
      body,
      [
        Authorization: download_token_response.authorization_token,
        "Content-Type": "application/json"
      ],
      []
    )
    |> process_http_result_json(
      "b2_get_download_authorization",
      fn json_result ->
        passthrough_error(
          json_result,
          fn json -> add_download_token(json, download_token_response) end
        )
      end
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
      time_requested: monotonic_time()
    }

    {:ok, download_token_response}
  end

  defp add_download_token(json, download_token_response) do
    updated_download_token_response = %DownloadTokenResponse{
      download_token_response
      | download_token: json["authorizationToken"]
    }

    {:ok, updated_download_token_response}
  end

  defp decode_json(json_string, caller) do
    case Jason.decode(json_string) do
      {:ok, _} = success -> success
      {:error, _} -> {:error, "Could not decode JSON for #{caller}."}
    end
  end

  defp validate_application_key(b2_application_key) when is_binary(b2_application_key) do
    case b2_application_key do
      "" -> {:error, "Missing B2 application key"}
      _ -> {:ok, b2_application_key}
    end
  end

  defp monotonic_time do
    System.convert_time_unit(System.monotonic_time(), :native, :second)
  end
end
