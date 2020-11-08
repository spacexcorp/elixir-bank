defmodule ElixirBank.Records.Record do
  use ElixirBank, :schema

  alias ElixirBank.Interactions.Like
  alias ElixirBank.Records.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "records" do
    field(:description, :string)
    field(:image_url, :string)
    field(:likes, :integer, default: 0)
    field(:title, :string)

    belongs_to(:category, Category, type: :binary_id)

    has_many(:user_likes, Like)

    timestamps()
  end

  @required_fields [:category_id, :description, :image_url, :title]
  @fields @required_fields
  def changeset(record = %__MODULE__{}, attrs) do
    record
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:category)
  end

  def filter_by_category_name(records, nil), do: records

  def filter_by_category_name(records, category_name) do
    Enum.filter(records, fn %__MODULE__{category: category = %Category{}} ->
      category.name == category_name
    end)
  end
end
