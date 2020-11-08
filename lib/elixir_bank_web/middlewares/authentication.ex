defmodule ElixirBankWeb.Middlewares.Authentication do
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  def call(resolution = %{context: %{profile_id: _, user_id: _}}, _config), do: resolution

  def call(resolution, _config) do
    error = {:error, %{code: :not_authenticated, error: "Not authenticated", message: "Not authenticated"}}
    Resolution.put_result(resolution, error)
  end
end
