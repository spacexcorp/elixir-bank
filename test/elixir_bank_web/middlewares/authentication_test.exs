defmodule ElixirBankWeb.Middlewares.AuthenticationTest do
  use ElixirBankWeb.ConnCase

  alias Absinthe.Resolution
  alias Ecto.UUID
  alias ElixirBankWeb.Middlewares.Authentication

  describe "call/2" do
    test "should return a resolution without errors when resoluton contains correct context" do
      resolution = %Resolution{context: %{profile_id: UUID.generate(), user_id: UUID.generate()}}

      assert %Resolution{errors: []} = Authentication.call(resolution, %{})
    end

    test "should return a resoluton with errors when resolution contains incorrect context" do
      resolution = %Resolution{context: %{}}

      assert %Resolution{
               errors: [%{code: :not_authenticated, error: "Not authenticated", message: "Not authenticated"}]
             } = Authentication.call(resolution, %{})
    end
  end
end
