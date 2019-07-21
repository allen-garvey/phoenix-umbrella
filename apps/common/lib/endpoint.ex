defmodule Common.Endpoint do

  @doc """
  Options for phoenix sessions

  The session will be stored in the cookie and signed,
  this means its contents can be read but not tampered with.
  Set :encryption_salt if you would also like to encrypt it.
  """
  def session_options() do
    [
      store: :cookie,
      key: "_umbrella_key",
      signing_salt: "hNWAwoxD",
    ]
  end
end
