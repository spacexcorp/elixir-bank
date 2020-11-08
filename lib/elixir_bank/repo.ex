defmodule ElixirBank.Repo do
  use Ecto.Repo,
    otp_app: :elixir_bank,
    adapter: Ecto.Adapters.Postgres
end
