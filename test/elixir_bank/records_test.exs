defmodule ElixirBank.RecordsTest do
  use ElixirBank.DataCase

  alias Ecto.{Changeset, UUID}
  alias ElixirBank.Records.{Category, Record}
  alias ElixirBank.{Records, Repo}

  import ElixirBank.Factory

  describe "list_records/1" do
    test "should return all records" do
      {:ok, record} = insert(Record)

      assert [fetched_record = %Record{}] = Records.list_records()
      assert fetched_record.id == record.id
      assert Ecto.assoc_loaded?(fetched_record.category)
      assert Ecto.assoc_loaded?(fetched_record.user_likes)
    end

    test "should return all records filtered by category name" do
      {:ok, category} = insert(Category, %{name: "Most"})
      {:ok, record} = insert(Record, %{category_id: category.id})
      {:ok, _} = insert(Record)

      assert [fetched_record = %Record{}] = Records.list_records(category.name)
      assert fetched_record.id == record.id
      assert Ecto.assoc_loaded?(fetched_record.category)
      assert Ecto.assoc_loaded?(fetched_record.user_likes)
    end
  end

  describe "list_most_liked_records/1" do
    @first_highest_likes 5
    @second_highest_likes 4
    @third_highest_likes 3

    setup do
      range = 1..5

      for likes <- range do
        Record
        |> build!()
        |> Map.put(:likes, likes)
        |> Repo.insert()
      end
    end

    test "should return most liked records with a limit" do
      limit = 3
      most_liked_records = Records.list_most_liked_records(limit)

      assert Enum.count(most_liked_records) == limit

      assert [
               %Record{likes: @first_highest_likes},
               %Record{likes: @second_highest_likes},
               %Record{likes: @third_highest_likes}
             ] = most_liked_records
    end
  end

  describe "get_record/1" do
    test "should return a record when record with given id does exist" do
      {:ok, record} = insert(Record)

      assert {:ok, fetched_record = %Record{}} = Records.get_record(record.id)
      assert fetched_record.id == record.id
      assert Ecto.assoc_loaded?(fetched_record.category)
      assert Ecto.assoc_loaded?(fetched_record.user_likes)
    end

    test "should return an error when record with given id does not exist" do
      assert {:error, :record_does_not_exist} == Records.get_record(UUID.generate())
    end
  end

  describe "create_record/1" do
    test "should return a created record when attrs are valid" do
      {:ok, attrs} = params_for(Record)

      assert {:ok, created_record = %Record{}} = Records.create_record(attrs)
      refute is_nil(created_record.id)
    end

    test "should return an error when attrs are not valid" do
      assert {:error, changeset = %Changeset{}} = Records.create_record(%{})
    end
  end

  describe "update_record/2" do
    test "should return an updated record when record with given id does exist and attrs are valid" do
      {:ok, record} = insert(Record)
      attrs = %{title: "some other title"}

      assert {:ok, updated_record = %Record{}} = Records.update_record(record.id, attrs)
      assert updated_record.id == record.id
      assert updated_record.title == attrs.title
    end

    test "should return an error when record with given id does not exist" do
      attrs = %{title: "some other title"}

      assert {:error, :record_does_not_exist} == Records.update_record(UUID.generate(), attrs)
    end

    test "should return an error when attrs are not valid" do
      {:ok, record} = insert(Record)
      attrs = %{title: nil}

      assert {:error, changeset = %Changeset{}} = Records.update_record(record.id, attrs)
    end
  end

  describe "data/0" do
    test "should return an Dataloader Ecto source" do
      assert %Dataloader.Ecto{repo: ElixirBank.Repo} = Records.data()
    end
  end
end
