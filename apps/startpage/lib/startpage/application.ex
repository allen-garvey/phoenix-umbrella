defmodule Startpage.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      # Startpage.Repo,
      # Start the endpoint when the application starts
      StartpageWeb.Endpoint,
      # Starts a worker by calling: Startpage.Worker.start_link(arg)
      # {Startpage.Worker, arg},
      {Phoenix.PubSub, [name: Startpage.PubSub, adapter: Phoenix.PubSub.PG2]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Startpage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    StartpageWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
