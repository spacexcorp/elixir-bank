defmodule ElixirBankWeb.Resolvers.RecordTest do
  use ElixirBankWeb.ConnCase

  alias Ecto.UUID
  alias ElixirBank.Accounts.User
  alias ElixirBank.Records.{Category, Record}
  alias ElixirBank.Repo
  alias ElixirBankWeb.Resolvers

  import ElixirBank.Factory

  describe "all_records/2" do
    test "should return all records" do
      {:ok, record} = insert(Record)
      attrs = %{}

      assert {:ok, records} = Resolvers.Record.all_records(attrs, nil)
      assert [fetched_record] = records
      assert fetched_record.id == record.id
    end

    test "should return all records filtered by category name" do
      {:ok, category} = insert(Category, %{name: "Most"})
      {:ok, record} = insert(Record, %{category_id: category.id})
      {:ok, _} = insert(Record)

      category_name = :most
      attrs = %{category_name: category_name}

      assert {:ok, records} = Resolvers.Record.all_records(attrs, nil)
      assert [fetched_record] = records
      assert fetched_record.id == record.id
    end
  end

  describe "most_liked_records/1" do
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
      attrs = %{limit: limit}

      assert {:ok, most_liked_records} = Resolvers.Record.most_liked_records(attrs, nil)
      assert Enum.count(most_liked_records) == limit

      assert [
               %Record{likes: @first_highest_likes},
               %Record{likes: @second_highest_likes},
               %Record{likes: @third_highest_likes}
             ] = most_liked_records
    end
  end

  describe "get_record/2" do
    test "should return a record when record with given id does exist" do
      {:ok, record} = insert(Record)
      attrs = %{id: record.id}

      assert {:ok, fetched_record = %Record{}} = Resolvers.Record.get_record(attrs, nil)
      assert fetched_record.id == record.id
    end

    test "should return an error when record with given id does not exist" do
      attrs = %{id: UUID.generate()}

      assert {:error, "record does not exist"} == Resolvers.Record.get_record(attrs, nil)
    end
  end

  describe "create_record/2" do
    test "should return a created record when attrs are valid" do
      {:ok, attrs} = params_for(Record)

      assert {:ok, %Record{}} = Resolvers.Record.create_record(attrs, nil)
    end

    test "should return an error when attrs are not valid" do
      assert {:error, "could not create record"} == Resolvers.Record.create_record(%{}, nil)
    end
  end

  describe "update_record/2" do
    test "should return an updated record when record with given id does exist and attrs are valid" do
      {:ok, record} = insert(Record)
      title = "some other title"
      attrs = %{id: record.id, params: %{title: "some other title"}}

      assert {:ok, updated_record = %Record{}} = Resolvers.Record.update_record(attrs, nil)
      assert updated_record.title == title
    end

    test "should return an error when record with given id does not exist" do
      attrs = %{id: UUID.generate(), params: %{title: "some other title"}}

      assert {:error, "could not update record"} == Resolvers.Record.update_record(attrs, nil)
    end

    test "should return an error when attrs are not valid" do
      {:ok, record} = insert(Record)
      attrs = %{id: record.id, params: %{title: nil}}

      assert {:error, "could not update record"} == Resolvers.Record.update_record(attrs, nil)
    end
  end

  describe "toggle_like/2" do
    test "should return a record with one more like when like does not exist, record with given id does exist and user with given id does exist" do
      {:ok, record} = insert(Record)
      {:ok, _} = insert(User, %{system: true})
      attrs = %{record_id: record.id}

      assert {:ok, liked_record = %Record{}} = Resolvers.Record.toggle_like(attrs, nil)
      assert liked_record.likes == record.likes + 1
    end

    test "should return a record with same likes when like does exist, record with given id does exist and user with given id does exist" do
      {:ok, record} = insert(Record)
      {:ok, _} = insert(User, %{system: true})
      attrs = %{record_id: record.id}

      assert {:ok, %Record{}} = Resolvers.Record.toggle_like(attrs, nil)
      assert {:ok, liked_record = %Record{}} = Resolvers.Record.toggle_like(attrs, nil)
      assert liked_record.likes == record.likes
    end

    test "should return an error when record with given id does not exist" do
      {:ok, _} = insert(User, %{system: true})
      attrs = %{record_id: UUID.generate()}

      assert {:error, "could not toggle like"} == Resolvers.Record.toggle_like(attrs, nil)
    end

    test "should return an error when system user does not exist" do
      {:ok, record} = insert(Record)
      attrs = %{record_id: record.id}

      assert {:error, "could not toggle like"} == Resolvers.Record.toggle_like(attrs, nil)
    end
  end
end
