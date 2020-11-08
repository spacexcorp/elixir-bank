defmodule ElixirBankWeb.Context do
  @behaviour Plug

  alias ElixirBankWeb.Token

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> build_context()
    |> case do
      {:ok, context} -> put_private(conn, :absinthe, %{context: context})
      _ -> conn |> put_status(403) |> halt()
    end
  end

  defp build_context(conn) do
    conn
    |> get_req_header("authorization")
    |> case do
      ["Bearer " <> auth_token] -> Token.verify(auth_token)
      [] -> {:ok, %{}}
      error -> error
    end
  end
end
