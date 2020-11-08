defmodule ElixirBankWeb.TokenTest do
  use ElixirBank.DataCase

  alias ElixirBankWeb.Token

  describe "sign/1" do
    test "should return a signed phoenix token" do
      data = "data"
      token = Token.sign(data)

      assert String.starts_with?(token, "SFMyNTY.")
    end
  end

  describe "verify/2" do
    test "should return the data when the phoenix token is valid" do
      data = "data"
      token = Token.sign(data)

      assert {:ok, "data"} == Token.verify(token)
    end

    test "should return an error when the phoenix token is invalid" do
      assert {:error, :invalid} == Token.verify("invalidToken")
    end

    test "should return an error when the phoenix token is expired" do
      data = "data"
      token = Token.sign(data)

      assert {:error, :expired} == Token.verify(token, 0)
    end
  end
end
