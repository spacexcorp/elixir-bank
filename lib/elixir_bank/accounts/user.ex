defmodule ElixirBank.Accounts.User do
  use ElixirBank, :schema

  alias ElixirBank.Accounts.Profile

  @email_format ~r/@/

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:auth_tokens, {:array, :string}, default: [])
    field(:date_of_birth, :date)
    field(:email, :string)
    field(:name, :string)
    field(:pin, :string, default: "0000")
    field(:system, :boolean)

    has_many(:profile, Profile)

    timestamps()
  end

  @required_fields [:date_of_birth, :email, :name, :pin]
  @fields [:auth_tokens, :system | @required_fields]
  def changeset(user = %__MODULE__{}, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, @email_format)
    |> validate_length(:pin, is: 4)
    |> unique_constraint(:email)
    |> unique_constraint(:system)
  end
end
