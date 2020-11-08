defmodule ElixirBankWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ElixirBankWeb.ConnCase, async: true`, although
  this option is not recommendded for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias ElixirBank.Accounts.{Profile, User}
  alias ElixirBank.Repo
  alias ElixirBank.Router.Helpers
  alias ElixirBankWeb.{Endpoint, Token}
  alias Phoenix.ConnTest

  import Plug.Conn

  using do
    quote do
      use ConnTest
      alias Helpers, as: Routes

      @endpoint Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    conn = ConnTest.build_conn()
    auth_conn = build_auth_conn()

    {:ok, conn: conn, auth_conn: auth_conn}
  end

  defp build_auth_conn do
    {:ok, user = %User{}} =
      Repo.insert(%User{date_of_birth: ~D[2000-01-01], email: "test.user@email.com", name: "Test User", pin: "0000"})

    {:ok, profile = %Profile{}} = Repo.insert(%Profile{user_id: user.id})
    token = Token.sign(%{profile_id: profile.id, user_id: user.id})

    ConnTest.build_conn() |> put_req_header("authorization", "Bearer " <> token)
  end
end
