defmodule ElixirBankWeb.Router do
  @dialyzer :no_match
  @dialyzer :no_return

  use ElixirBankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ElixirBankWeb.Context
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: ElixirBankWeb.Schema,
      interface: :simple,
      context: %{pubsub: ElixirBankWeb.Endpoint}

    forward "/", Absinthe.Plug,
      schema: ElixirBankWeb.Schema,
      interface: :simple,
      context: %{pubsub: ElixirBankWeb.Endpoint}
  end
end
