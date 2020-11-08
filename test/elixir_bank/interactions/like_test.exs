defmodule ElixirBank.Interactions.LikeTest do
  use ElixirBank.DataCase

  alias Ecto.UUID
  alias ElixirBank.Interactions.Like

  describe "changeset/2" do
    @valid_attrs %{
      record_id: UUID.generate(),
      user_id: UUID.generate()
    }

    test "should return a valid changeset when attrs are valid" do
      changeset = Like.changeset(%Like{}, @valid_attrs)

      assert changeset.valid?
    end

    test "should return an invalid changeset when attrs are not valid" do
      changeset = Like.changeset(%Like{}, %{})

      refute changeset.valid?
      assert errors_on(changeset) == %{record_id: ["can't be blank"], user_id: ["can't be blank"]}
    end
  end
end
