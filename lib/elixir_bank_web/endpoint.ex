defmodule ElixirBankWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_bank

  plug Plug.Static,
    at: "/",
    from: :elixir_bank,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_elixir_bank_key",
    signing_salt: "BSAS/UYZ"

  plug CORSPlug
  plug ElixirBankWeb.Router
end
