defmodule ElixirBank.InteractionsTest do
  use ElixirBank.DataCase

  alias Ecto.UUID
  alias ElixirBank.Accounts.User
  alias ElixirBank.Interactions
  alias ElixirBank.Records.Record

  import ElixirBank.Factory

  describe "toggle_like/1" do
    test "should return a record with one more like when like does not exist, record with given id does exist and user with given id does exist" do
      {:ok, record} = insert(Record)
      {:ok, _} = insert(User, %{system: true})

      assert {:ok, liked_record = %Record{}} = Interactions.toggle_like(record.id)
      assert liked_record.likes == record.likes + 1
    end

    test "should return a record with same likes when like does exist, record with given id does exist and user with given id does exist" do
      {:ok, record} = insert(Record)
      {:ok, _} = insert(User, %{system: true})

      assert {:ok, %Record{}} = Interactions.toggle_like(record.id)
      assert {:ok, liked_record = %Record{}} = Interactions.toggle_like(record.id)
      assert liked_record.likes == record.likes
    end

    test "should return an error when record with given id does not exist" do
      {:ok, _} = insert(User, %{system: true})

      assert {:error, :record_does_not_exist} == Interactions.toggle_like(UUID.generate())
    end

    test "should return an error when system user does not exist" do
      {:ok, record} = insert(Record)

      assert {:error, :system_user_does_not_exist} == Interactions.toggle_like(record.id)
    end
  end
end
