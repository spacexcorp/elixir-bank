defmodule ElixirBank.Interactions.Like do
  use ElixirBank, :schema

  alias ElixirBank.Accounts.User
  alias ElixirBank.Records.Record

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "likes" do
    belongs_to(:record, Record, type: :binary_id)
    belongs_to(:user, User, type: :binary_id)

    timestamps()
  end

  @required_fields [:record_id, :user_id]
  @fields @required_fields
  def changeset(like = %__MODULE__{}, attrs) do
    like
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:record)
    |> assoc_constraint(:user)
    |> unique_constraint(:record_id, name: :likes_record_id_user_id_index)
  end
end
