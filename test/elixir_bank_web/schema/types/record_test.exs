defmodule ElixirBankWeb.Schema.Types.RecordTest do
  use ElixirBankWeb.ConnCase

  alias Ecto.UUID
  alias ElixirBank.Accounts.User
  alias ElixirBank.Interactions.Like
  alias ElixirBank.Records.{Category, Record}
  alias ElixirBank.Repo

  import ElixirBank.Factory

  describe "allRecords" do
    @all_records_query """
      {
        allRecords {
          id
          userLikes {
            userId
          }
        }
      }
    """

    @all_records_query_with_category_name """
      {
        allRecords(categoryName: MOST) {
          id
        }
      }
    """

    test "should return all records", %{conn: conn} do
      {:ok, record} = insert(Record)
      {:ok, user} = insert(User)
      {:ok, _} = insert(Like, %{record_id: record.id, user_id: user.id})

      response =
        conn
        |> post("/graphiql", %{query: @all_records_query})
        |> json_response(:ok)
        |> Access.get("data")

      fetched_records = response["allRecords"]
      fetched_record = Enum.find(fetched_records, &(&1["id"] == record.id))

      assert [user_like] = fetched_record["userLikes"]
      assert user_like["userId"] == user.id
    end

    test "should return all records filtered by category name", %{conn: conn} do
      {:ok, category} = insert(Category, %{name: "Most"})
      {:ok, record} = insert(Record, %{category_id: category.id})
      {:ok, _} = insert(Record)

      response =
        conn
        |> post("/graphiql", %{query: @all_records_query_with_category_name})
        |> json_response(:ok)
        |> Access.get("data")

      assert [fetched_record] = response["allRecords"]
      assert fetched_record["id"] == record.id
    end
  end

  describe "mostLikedRecords" do
    @limit 3
    @first_highest_likes 5
    @second_highest_likes 4
    @third_highest_likes 3

    @most_liked_records_query """
      {
        mostLikedRecords(
          limit: #{@limit}
        ) {
          likes
        }
      }
    """

    setup do
      range = 1..5

      for likes <- range do
        Record
        |> build!()
        |> Map.put(:likes, likes)
        |> Repo.insert()
      end
    end

    test "should return most liked records with a limit", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @most_liked_records_query})
        |> json_response(:ok)
        |> Access.get("data")

      most_liked_records = response["mostLikedRecords"]

      assert [
               %{"likes" => @first_highest_likes},
               %{"likes" => @second_highest_likes},
               %{"likes" => @third_highest_likes}
             ] == most_liked_records
    end
  end

  describe "getRecord" do
    @id UUID.generate()

    @get_record_query """
      {
        getRecord(
          id: "#{@id}"
        ) {
          id
        }
      }
    """

    test "should return a record when record with given id does exist", %{conn: conn} do
      {:ok, record} = insert(Record, %{id: @id})

      response =
        conn
        |> post("/graphiql", %{query: @get_record_query})
        |> json_response(:ok)
        |> Access.get("data")

      fetched_record = response["getRecord"]

      refute is_nil(fetched_record)
      assert fetched_record["id"] == record.id
    end

    test "should return an error when record with given id does not exist", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @get_record_query})
        |> json_response(:ok)

      fetched_record = response["data"]["getRecord"]
      errors = response["errors"]

      assert is_nil(fetched_record)
      assert [%{"message" => "record does not exist"}] = errors
    end
  end

  describe "createRecord" do
    @category_id UUID.generate()

    @create_record_mutation """
      mutation {
        createRecord(
          category_id: "#{@category_id}",
          description: "some description",
          image_url: "some image url",
          title: "some title"
        ) {
          id
        }
      }
    """

    @create_record_mutation_with_invalid_attrs """
      mutation {
        createRecord(
          category_id: "#{UUID.generate()}",
          description: "",
          image_url: "",
          title: ""
        ) {
          id
        }
      }
    """

    test "should return a created record when attrs are valid", %{auth_conn: auth_conn} do
      {:ok, _} = insert(Category, %{id: @category_id})

      response =
        auth_conn
        |> post("/graphiql", %{query: @create_record_mutation})
        |> json_response(:ok)
        |> Map.get("data")

      created_record = response["createRecord"]

      refute is_nil(created_record)
    end

    test "should return an error when attrs are not valid", %{auth_conn: auth_conn} do
      response =
        auth_conn
        |> post("/graphiql", %{query: @create_record_mutation_with_invalid_attrs})
        |> json_response(:ok)

      created_record = response["data"]["createRecord"]
      errors = response["errors"]

      assert is_nil(created_record)
      assert [%{"message" => "could not create record"}] = errors
    end

    test "should return an error when connection is not authenticated", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @create_record_mutation})
        |> json_response(:ok)

      created_record = response["data"]["createRecord"]
      errors = response["errors"]

      assert is_nil(created_record)
      assert [%{"message" => "Not authenticated"}] = errors
    end
  end

  describe "updateRecord" do
    @id UUID.generate()
    @title "some other title"

    @update_record_mutation """
      mutation {
        updateRecord(
          id: "#{@id}"
          params: {
            title: "#{@title}"
          }
        ) {
          id
          title
        }
      }
    """

    @update_record_mutation_with_unexistent_record """
      mutation {
        updateRecord(
          id: "#{UUID.generate()}"
          params: {
            title: "#{@title}"
          }
        ) {
          id
        }
      }
    """

    @update_record_mutation_with_invalid_attrs """
      mutation {
        updateRecord(
          id: "#{@id}"
          params: {
            title: ""
          }
        ) {
          id
        }
      }
    """

    test "should return an updated record when record with given id does exist and attrs are valid", %{
      auth_conn: auth_conn
    } do
      {:ok, record} = insert(Record, %{id: @id})

      response =
        auth_conn
        |> post("/graphiql", %{query: @update_record_mutation})
        |> json_response(:ok)
        |> Access.get("data")

      updated_record = response["updateRecord"]

      assert updated_record["id"] == record.id
      assert updated_record["title"] == @title
    end

    test "should return an error when record with given id does not exist", %{auth_conn: auth_conn} do
      response =
        auth_conn
        |> post("/graphiql", %{query: @update_record_mutation_with_unexistent_record})
        |> json_response(:ok)

      updated_record = response["data"]["updateRecord"]
      errors = response["errors"]

      assert is_nil(updated_record)
      assert [%{"message" => "could not update record"}] = errors
    end

    test "should return an error when attrs are not valid", %{auth_conn: auth_conn} do
      {:ok, _} = insert(Record, %{id: @id})

      response =
        auth_conn
        |> post("/graphiql", %{query: @update_record_mutation_with_invalid_attrs})
        |> json_response(:ok)

      updated_record = response["data"]["updateRecord"]
      errors = response["errors"]

      assert is_nil(updated_record)
      assert [%{"message" => "could not update record"}] = errors
    end

    test "should return an error when connection is not authenticated", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @update_record_mutation})
        |> json_response(:ok)

      updated_record = response["data"]["updateRecord"]
      errors = response["errors"]

      assert is_nil(updated_record)
      assert [%{"message" => "Not authenticated"}] = errors
    end
  end

  describe "toggleLike" do
    @record_id UUID.generate()

    @toggle_like_mutation """
      mutation {
        toggleLike(
          record_id: "#{@record_id}"
        ) {
          id
          likes
        }
      }
    """

    @toggle_like_mutation_with_unexistent_record """
      mutation {
        toggleLike(
          record_id: "#{UUID.generate()}"
        ) {
          id
        }
      }
    """

    @toggle_like_mutation_with_unexistent_user """
      mutation {
        toggleLike(
          record_id: "#{@record_id}"
        ) {
          id
        }
      }
    """

    test "should return a record with one more like when like does not exist, record with given id does exist and user with given id does exist",
         %{auth_conn: auth_conn} do
      {:ok, record} = insert(Record, %{id: @record_id})
      {:ok, _} = insert(User, %{system: true})

      response =
        auth_conn
        |> post("/graphiql", %{query: @toggle_like_mutation})
        |> json_response(:ok)
        |> Access.get("data")

      liked_record = response["toggleLike"]

      assert liked_record["id"] == record.id
      assert liked_record["likes"] == record.likes + 1
    end

    test "should return a record with same likes when like does exist, record with given id does exist and user with given id does exist",
         %{auth_conn: auth_conn} do
      {:ok, record} = insert(Record, %{id: @record_id})
      {:ok, _} = insert(User, %{system: true})

      auth_conn
      |> post("/graphiql", %{query: @toggle_like_mutation})
      |> json_response(:ok)
      |> Access.get("data")

      response =
        auth_conn
        |> post("/graphiql", %{query: @toggle_like_mutation})
        |> json_response(:ok)
        |> Access.get("data")

      liked_record = response["toggleLike"]

      assert liked_record["id"] == record.id
      assert liked_record["likes"] == record.likes
    end

    test "should return an error when record with given id does not exist", %{auth_conn: auth_conn} do
      {:ok, _} = insert(User, %{system: true})

      response =
        auth_conn
        |> post("/graphiql", %{query: @toggle_like_mutation_with_unexistent_record})
        |> json_response(:ok)

      liked_record = response["data"]["toggleLike"]
      errors = response["errors"]

      assert is_nil(liked_record)
      assert [%{"message" => "could not toggle like"}] = errors
    end

    test "should return an error when system user does not exist", %{auth_conn: auth_conn} do
      {:ok, _} = insert(Record, %{id: @record_id})

      response =
        auth_conn
        |> post("/graphiql", %{query: @toggle_like_mutation_with_unexistent_user})
        |> json_response(:ok)

      liked_record = response["data"]["toggleLike"]
      errors = response["errors"]

      assert is_nil(liked_record)
      assert [%{"message" => "could not toggle like"}] = errors
    end

    test "should return an error when connection is not authenticated", %{conn: conn} do
      response =
        conn
        |> post("/graphiql", %{query: @toggle_like_mutation})
        |> json_response(:ok)

      liked_record = response["data"]["toggleLike"]
      errors = response["errors"]

      assert is_nil(liked_record)
      assert [%{"message" => "Not authenticated"}] = errors
    end
  end
end
