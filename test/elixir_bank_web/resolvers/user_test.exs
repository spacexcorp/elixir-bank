defmodule ElixirBankWeb.Resolvers.UserTest do
  use ElixirBankWeb.ConnCase

  alias Ecto.UUID
  alias ElixirBank.Accounts.{Profile, User}
  alias ElixirBank.Repo
  alias ElixirBankWeb.Resolvers

  import ElixirBank.Factory

  describe "get_user/2" do
    test "should return a user when the context does have an user_id and user does exist" do
      {:ok, user} = insert(User)
      info = %{context: %{user_id: user.id}}

      assert {:ok, fetched_user = %User{}} = Resolvers.User.get_user(nil, info)
      assert fetched_user.id == user.id
    end

    test "should return an error when the context does have an user_id and user does not exist" do
      info = %{context: %{user_id: UUID.generate()}}

      assert {:error, "user does not exist"} == Resolvers.User.get_user(nil, info)
    end

    test "should return an error when the context does not have an user_id" do
      assert {:error, "user does not exist"} == Resolvers.User.get_user(nil, nil)
    end
  end

  describe "create_user/2" do
    test "should return a created user with auth token and a profile when attrs are valid" do
      {:ok, attrs} = params_for(User)

      assert {:ok, user = %User{}} = Resolvers.User.create_user(attrs, nil)
      refute user.auth_tokens == []

      profile = Profile |> Repo.all() |> Enum.find(&(&1.user_id == user.id))

      refute is_nil(profile)
    end

    test "should return an error when attrs are not valid" do
      assert {:error, "could not create user"} == Resolvers.User.create_user(%{}, nil)
    end
  end
end
