defmodule ElixirBank.Records.Category do
  use ElixirBank, :schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "categories" do
    field(:name, :string)

    timestamps()
  end

  @required_fields [:name]
  @fields @required_fields
  def changeset(category = %__MODULE__{}, attrs) do
    category
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end
end
