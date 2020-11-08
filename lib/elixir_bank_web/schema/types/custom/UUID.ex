defmodule ElixirBankWeb.Schema.Types.Custom.UUID do
  @moduledoc """
  The UUID scalar type allows UUID4 compliant strings to be passed in and out.
  Requires `{:ecto, ">= 0.0.0"}` package: https://github.com/elixir-ecto/ecto
  """
  use Absinthe.Schema.Notation

  alias Ecto.UUID

  scalar :uuid, name: "UUID" do
    description("""
    The `UUID` scalar type represents UUID4 compliant string data, represented as UTF-8
    character sequences. The UUID4 type is most often used to represent unique
    human-readable ID strings.
    """)

    serialize(&encode/1)
    parse(&decode/1)
  end

  defp encode(value), do: value

  defp decode(%Absinthe.Blueprint.Input.String{value: value}), do: UUID.cast(value)
  defp decode(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}
  defp decode(_), do: :error
end
