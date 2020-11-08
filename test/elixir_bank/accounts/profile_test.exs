defmodule ElixirBank.Accounts.ProfileTest do
  use ElixirBank.DataCase

  alias Ecto.UUID
  alias ElixirBank.Accounts.Profile

  describe "changeset/2" do
    @valid_attrs %{
      user_id: UUID.generate()
    }

    test "should return a valid changeset when attrs are valid" do
      changeset = Profile.changeset(%Profile{}, @valid_attrs)

      assert changeset.valid?
    end

    test "should return an invalid changeset when attrs are not valid" do
      changeset = Profile.changeset(%Profile{}, %{})

      refute changeset.valid?
      assert errors_on(changeset) == %{user_id: ["can't be blank"]}
    end
  end
end
