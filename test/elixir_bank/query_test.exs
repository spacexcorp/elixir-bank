defmodule Post do
  use Ecto.Schema

  @primary_key {:id, :binary_id, []}
  schema "posts" do
    field :title, :string
    field :text, :string
  end
end

defmodule ElixirBank.QueryTest do
  use ElixirBank.DataCase

  alias Ecto.UUID
  alias ElixirBank.Query

  describe "search/3" do
    test "should return a queriable with a where clause checking if field is_nil when value is nil" do
      queriable = Query.search(Post, :id, nil)

      assert inspect(queriable) == ~s{#Ecto.Query<from p0 in Post, where: is_nil(p0.id)>}
    end

    test "should return a queriable with a where clause" do
      id = UUID.generate()
      queriable = Query.search(Post, :id, id)

      assert inspect(queriable) == ~s{#Ecto.Query<from p0 in Post, where: p0.id == ^\"#{id}\">}
    end
  end

  describe "sort_by/3" do
    test "should return a queriable with an ascending order by clause when order is :asc" do
      queriable = Query.sort_by(Post, :title, :asc)

      assert inspect(queriable) == ~s{#Ecto.Query<from p0 in Post, order_by: [asc: p0.title]>}
    end

    test "should return a queriable with a descending order by clause when order is :desc" do
      queriable = Query.sort_by(Post, :title, :desc)

      assert inspect(queriable) == ~s{#Ecto.Query<from p0 in Post, order_by: [desc: p0.title]>}
    end
  end

  describe "limit_by/2" do
    test "should return a queriable with a limit clause" do
      limit = 2
      queriable = Query.limit_by(Post, limit)

      assert inspect(queriable) == ~s{#Ecto.Query<from p0 in Post, limit: ^#{limit}>}
    end
  end

  describe "default/2" do
    test "should return a queriable" do
      queriable = Query.default(Post, nil)

      assert inspect(queriable) == ~s{Post}
    end
  end
end
