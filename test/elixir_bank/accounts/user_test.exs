defmodule ElixirBank.Accounts.UserTest do
  use ElixirBank.DataCase

  alias ElixirBank.Accounts.User

  describe "changeset/2" do
    @valid_attrs %{
      date_of_birth: ~D[2000-01-01],
      email: "some@email.com",
      name: "some name",
      pin: "0000"
    }

    test "should return a valid changeset when attrs are valid" do
      changeset = User.changeset(%User{}, @valid_attrs)

      assert changeset.valid?
    end

    test "should return an invalid changeset when attrs are not valid" do
      changeset = User.changeset(%User{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               date_of_birth: ["can't be blank"],
               email: ["can't be blank"],
               name: ["can't be blank"]
             }
    end

    test "should return an invalid changeset when email have invalid format" do
      attrs = %{@valid_attrs | email: "email"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == %{email: ["has invalid format"]}
    end

    test "should return an invalid changeset when pin have less than 4 characters" do
      attrs = %{@valid_attrs | pin: "000"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == %{pin: ["should be 4 character(s)"]}
    end

    test "should return an invalid changeset when pin have more than 4 characters" do
      attrs = %{@valid_attrs | pin: "00000"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert errors_on(changeset) == %{pin: ["should be 4 character(s)"]}
    end
  end
end
