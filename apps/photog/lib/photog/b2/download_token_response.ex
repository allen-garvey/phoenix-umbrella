defmodule Photog.B2.DownloadTokenResponse do
    @derive {Inspect, only: [:api_url, :download_url]}
    
    defstruct [:api_url, :download_url, :authorization_token, :download_token, :bucket_id, :file_name_prefix]
end