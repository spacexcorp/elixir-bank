defmodule ElixirBank.Records.CategoryTest do
  use ElixirBank.DataCase

  alias ElixirBank.Records.Category

  describe "changeset/2" do
    @valid_attrs %{
      name: "some name"
    }

    test "should return a valid changeset when attrs are valid" do
      changeset = Category.changeset(%Category{}, @valid_attrs)

      assert changeset.valid?
    end

    test "should return an invalid changeset when attrs are not valid" do
      changeset = Category.changeset(%Category{}, %{})

      refute changeset.valid?
      assert errors_on(changeset) == %{name: ["can't be blank"]}
    end
  end
end
