defmodule ElixirBankWeb.Resolvers.User do
  alias Ecto.Changeset
  alias ElixirBank.Accounts
  alias ElixirBank.Accounts.{Profile, User}
  alias ElixirBankWeb.Token

  def get_user(_attrs, info) do
    user_id = get_user_id(info)

    user_id
    |> Accounts.get_user()
    |> case do
      {:ok, user = %User{}} -> {:ok, user}
      {:error, :user_does_not_exist} -> {:error, "user does not exist"}
    end
  end

  defp get_user_id(%{context: %{user_id: user_id}}), do: user_id
  defp get_user_id(_), do: nil

  def create_user(attrs, _info) do
    with {:ok, user = %User{}} <- Accounts.create_user(attrs),
         {:ok, profile = %Profile{}} <- Accounts.create_profile(%{user_id: user.id}),
         auth_token <- generate_auth_token(profile, user),
         {:ok, updated_user = %User{}} <- Accounts.update_user_auth_token(user.id, auth_token) do
      {:ok, updated_user}
    else
      {:error, %Changeset{}} -> {:error, "could not create user"}
    end
  end

  defp generate_auth_token(profile = %Profile{}, user = %User{}) do
    profile
    |> get_token_data(user)
    |> Token.sign()
  end

  defp get_token_data(profile = %Profile{}, user = %User{}), do: %{profile_id: profile.id, user_id: user.id}
end
