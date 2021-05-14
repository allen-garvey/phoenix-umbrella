defmodule Common.Endpoint do

  def cookie_domain do
    System.get_env("UMBRELLA_COOKIE_DOMAIN", ".umbrella.test")
  end

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
      domain: cookie_domain(),
      max_age: 24*60*60*30 # 30 days
    ]
  end
end
