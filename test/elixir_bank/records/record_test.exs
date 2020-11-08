defmodule ElixirBank.Records.RecordTest do
  use ElixirBank.DataCase

  alias Ecto.UUID
  alias ElixirBank.Records.{Category, Record}

  import ElixirBank.Factory

  describe "changeset/2" do
    @valid_attrs %{
      category_id: UUID.generate(),
      description: "some description",
      image_url: "some image url",
      title: "some title"
    }

    test "should return a valid changeset when attrs are valid" do
      changeset = Record.changeset(%Record{}, @valid_attrs)

      assert changeset.valid?
    end

    test "should return a valid changeset with likes as 0 when attrs are valid and likes are nil" do
      changeset = Record.changeset(%Record{}, @valid_attrs)

      assert changeset.valid?
      assert get_field(changeset, :likes) == 0
    end

    test "should return a valid changeset with same likes when attrs are valid and likes are not nil" do
      likes = 2
      changeset = Record.changeset(%Record{likes: likes}, @valid_attrs)

      assert changeset.valid?
      assert get_field(changeset, :likes) == likes
    end

    test "should return an invalid changeset when attrs are not valid" do
      changeset = Record.changeset(%Record{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               category_id: ["can't be blank"],
               description: ["can't be blank"],
               image_url: ["can't be blank"],
               title: ["can't be blank"]
             }
    end
  end

  describe "filter_by_category_name/2" do
    test "should return all records when the given category name is nil" do
      {:ok, record} = build(Record)
      records = [record]

      assert [filtered_record = %Record{}] = Record.filter_by_category_name(records, nil)
      assert filtered_record.id == record.id
    end

    test "should return filtered records when the given category name is not nil" do
      {:ok, fastest_category} = build(Category, %{name: "Fastest"})
      record_in_fastest_category = Record |> build!() |> Map.put(:category, fastest_category)

      {:ok, most_category} = build(Category, %{name: "Most"})
      record_in_most_category = Record |> build!() |> Map.put(:category, most_category)

      records = [record_in_fastest_category, record_in_most_category]

      assert [filtered_record = %Record{}] = Record.filter_by_category_name(records, fastest_category.name)
      assert filtered_record.id == record_in_fastest_category.id
    end
  end
end
