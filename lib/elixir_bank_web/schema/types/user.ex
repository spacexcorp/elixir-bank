defmodule ElixirBankWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

  alias ElixirBankWeb.Middlewares.Authentication
  alias ElixirBankWeb.Resolvers.User

  @desc "The `User` object represents an entity that is authenticated and can do the actions on the system."
  object :user do
    field(:auth_tokens, non_null(list_of(non_null(:string))))
    field(:date_of_birth, non_null(:date))
    field(:email, non_null(:string))
    field(:id, non_null(:uuid))
    field(:name, non_null(:string))
    field(:pin, non_null(:string))
  end

  object :user_queries do
    @desc "The `getUser` query return the logged `User`."
    field :get_user, :user do
      middleware(Authentication)

      resolve(&User.get_user/2)
    end
  end

  object :user_mutations do
    @desc "The `createUser` mutation returns a created `User`."
    field :create_user, :user do
      arg(:date_of_birth, non_null(:date))
      arg(:email, non_null(:string))
      arg(:name, non_null(:string))
      arg(:pin, :string)

      resolve(&User.create_user/2)
    end
  end
end
