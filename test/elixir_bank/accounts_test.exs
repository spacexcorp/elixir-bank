defmodule ElixirBank.AccountsTest do
  use ElixirBank.DataCase

  alias Ecto.{Changeset, UUID}
  alias ElixirBank.Accounts
  alias ElixirBank.Accounts.{Profile, User}

  import ElixirBank.Factory

  describe "get_user/1" do
    test "should return a user when user with given id does exist" do
      {:ok, user} = insert(User)

      assert {:ok, fetched_user = %User{}} = Accounts.get_user(user.id)
      assert fetched_user.id == user.id
    end

    test "should return an error when user with given id does not exist" do
      assert {:error, :user_does_not_exist} == Accounts.get_user(UUID.generate())
    end
  end

  describe "get_system_user/0" do
    test "should return the system user when the system user exist" do
      {:ok, system_user} = insert(User, %{system: true})

      assert {:ok, fetched_system_user = %User{}} = Accounts.get_system_user()
      assert fetched_system_user.id == system_user.id
    end

    test "should return an error when system user does not exist" do
      assert {:error, :system_user_does_not_exist} == Accounts.get_system_user()
    end
  end

  describe "create_profile/1" do
    test "should return a created profile when attrs are valid" do
      {:ok, attrs} = params_for(Profile)

      assert {:ok, created_profile = %Profile{}} = Accounts.create_profile(attrs)
    end

    test "should return an error when attrs are not valid" do
      assert {:error, changeset = %Changeset{}} = Accounts.create_profile(%{})
    end
  end

  describe "create_user/1" do
    test "should return a created user when attrs are valid" do
      {:ok, attrs} = params_for(User)

      assert {:ok, created_user = %User{}} = Accounts.create_user(attrs)
    end

    test "should return an error when attrs are not valid" do
      assert {:error, changeset = %Changeset{}} = Accounts.create_user(%{})
    end

    test "should return an error when user with the same email already exists" do
      email = "some@email.com"
      {:ok, _} = insert(User, %{email: email})
      {:ok, attrs} = params_for(User)
      updated_attrs = %{attrs | email: email}

      assert {:error, changeset = %Changeset{}} = Accounts.create_user(updated_attrs)
      assert errors_on(changeset) == %{email: ["has already been taken"]}
    end

    test "should return an error when a system user already exists" do
      {:ok, _} = insert(User, %{system: true})
      {:ok, attrs} = params_for(User)
      updated_attrs = Map.put(attrs, :system, true)

      assert {:error, changeset = %Changeset{}} = Accounts.create_user(updated_attrs)
      assert errors_on(changeset) == %{system: ["has already been taken"]}
    end
  end

  describe "update_user_auth_token/2" do
    test "should return an updated user with the auth token updated when user exist" do
      {:ok, user} = insert(User, %{auth_tokens: []})
      auth_token = "fake_auth_token"

      assert {:ok, updated_user = %User{}} = Accounts.update_user_auth_token(user.id, auth_token)
      assert updated_user.auth_tokens == [auth_token]
    end

    test "should return an error when user does not exist" do
      auth_token = "fake_auth_token"

      assert {:error, :user_does_not_exist} == Accounts.update_user_auth_token(UUID.generate(), auth_token)
    end
  end
end
