defmodule StravaGearData.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      StravaGearData.Repo,
      # Start the Telemetry supervisor
      StravaGearDataWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: StravaGearData.PubSub},
      # Start the Endpoint (http/https)
      StravaGearDataWeb.Endpoint,
      # Start a worker by calling: StravaGearData.Worker.start_link(arg)
      {Task.Supervisor, name: StravaGearData.DataCollection.Supervisor, max_restarts: 5}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StravaGearData.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    StravaGearDataWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
