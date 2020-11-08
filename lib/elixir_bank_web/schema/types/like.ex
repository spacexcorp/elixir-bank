defmodule ElixirBankWeb.Schema.Types.Like do
  use Absinthe.Schema.Notation

  @desc "The `Like` object represents an entity that is the like relation between a `Record` and an `User`."
  object :like do
    field(:record_id, non_null(:uuid))
    field(:user_id, non_null(:uuid))
  end
end
