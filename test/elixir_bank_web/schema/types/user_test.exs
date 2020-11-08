defmodule ElixirBankWeb.Schema.Types.UserTest do
  use ElixirBankWeb.ConnCase

  alias ElixirBank.Accounts.Profile
  alias ElixirBank.Repo

  describe "getUser" do
    @get_user_query """
      {
        getUser {
          id
        }
      }
    """

    test "should return the current user", %{auth_conn: auth_conn} do
      response =
        auth_conn
        |> post("/graphiql", %{query: @get_user_query})
        |> json_response(:ok)
        |> Access.get("data")

      fetched_user = response["getUser"]

      refute is_nil(fetched_user)
    end

    test "should return an error when connection is not authenticated", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @get_user_query})
        |> json_response(:ok)

      fetched_user = response["data"]["getUser"]
      errors = response["errors"]

      assert is_nil(fetched_user)
      assert [%{"message" => "Not authenticated"}] = errors
    end
  end

  describe "createUser" do
    @create_user_mutation """
      mutation {
        createUser(
          dateOfBirth: "2000-01-01",
          email: "some@email.com",
          name: "some name",
          pin: "0000"
        ) {
          id
          authTokens
        }
      }
    """

    @create_user_mutation_with_invalid_attrs """
      mutation {
        createUser(
          dateOfBirth: "2000-01-01",
          email: "",
          name: "",
          pin: ""
        ) {
          id
        }
      }
    """

    test "should return a created user with auth token and a profile when attrs are valid", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @create_user_mutation})
        |> json_response(:ok)
        |> Map.get("data")

      created_user = response["createUser"]
      profile = Profile |> Repo.all() |> Enum.find(&(&1.user_id == created_user["id"]))

      refute is_nil(created_user)
      refute created_user["authTokens"] == []
      refute is_nil(profile)
    end

    test "should return an error when attrs are not valid", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @create_user_mutation_with_invalid_attrs})
        |> json_response(:ok)

      created_user = response["data"]["createUser"]
      errors = response["errors"]

      assert is_nil(created_user)
      assert [%{"message" => "could not create user"}] = errors
    end
  end
end
