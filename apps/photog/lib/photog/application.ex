defmodule Photog.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      Photog.Repo,
      # Start the endpoint when the application starts
      PhotogWeb.Endpoint,
      # Start your own worker by calling: Photog.Worker.start_link(arg1, arg2, arg3)
      # worker(Photog.Worker, [arg1, arg2, arg3]),
      {Phoenix.PubSub, [name: Photog.PubSub, adapter: Phoenix.PubSub.PG2]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Photog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhotogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
