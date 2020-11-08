defmodule ElixirBank.Accounts.Profile do
  use ElixirBank, :schema

  alias ElixirBank.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "profiles" do
    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  @required_fields [:user_id]
  @fields @required_fields
  def changeset(profile = %__MODULE__{}, attrs) do
    profile
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
