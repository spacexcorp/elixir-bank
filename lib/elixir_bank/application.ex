defmodule ElixirBank.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ElixirBank.Repo,
      ElixirBankWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ElixirBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ElixirBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
