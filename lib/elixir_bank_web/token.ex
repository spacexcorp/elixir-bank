defmodule ElixirBankWeb.Token do
  alias ElixirBankWeb.Endpoint

  @max_age 86_400
  @salt :crypto.strong_rand_bytes(32)

  def sign(data), do: Phoenix.Token.sign(Endpoint, @salt, data)

  def verify(token, max_age \\ @max_age), do: Phoenix.Token.verify(Endpoint, @salt, token, max_age: max_age)
end
