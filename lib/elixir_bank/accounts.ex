defmodule ElixirBank.Accounts do
  alias Ecto.Multi
  alias ElixirBank.Accounts.{Profile, User}
  alias ElixirBank.{Query, Repo}

  def get_user(user_id) do
    User
    |> Query.search(:id, user_id)
    |> Repo.one()
    |> case do
      nil -> {:error, :user_does_not_exist}
      user = %User{} -> {:ok, user}
    end
  end

  def get_system_user do
    User
    |> Query.search(:system, true)
    |> Repo.one()
    |> case do
      nil -> {:error, :system_user_does_not_exist}
      user = %User{} -> {:ok, user}
    end
  end

  def create_profile(attrs) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_auth_token(user_id, auth_token) do
    Multi.new()
    |> Multi.run(:user, fn _, _ -> get_user(user_id) end)
    |> Multi.update(:updated_user, fn %{user: user = %User{}} ->
      auth_tokens = [auth_token | user.auth_tokens]
      User.changeset(user, %{auth_tokens: auth_tokens})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{updated_user: updated_user = %User{}}} -> {:ok, updated_user}
      {:error, _, reason, _} -> {:error, reason}
    end
  end
end
