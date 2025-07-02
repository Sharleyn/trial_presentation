defmodule TrialGroup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TrialGroupWeb.Telemetry,
      TrialGroup.Repo,
      {DNSCluster, query: Application.get_env(:trial_group, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TrialGroup.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TrialGroup.Finch},
      # Start a worker by calling: TrialGroup.Worker.start_link(arg)
      # {TrialGroup.Worker, arg},
      # Start to serve requests, typically the last entry
      TrialGroupWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TrialGroup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrialGroupWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
