defmodule ElixirBankWeb.Schema.Types.Custom.Date do
  @moduledoc """
  The Date scalar type allows iso8601 date compliant strings to be passed in and out.
  """
  use Absinthe.Schema.Notation

  @desc """
  The [`Date`](https://hexdocs.pm/elixir/Date.html) scalar type represents a date.
  The Date appears in a JSON response as an ISO8601 formatted string. The parsed
  date string will be converted to UTC.
  """
  scalar :date, name: "Date" do
    serialize(&Date.to_iso8601/1)
    parse(&parse_date/1)
  end

  defp parse_date(%Absinthe.Blueprint.Input.String{value: value}) do
    value
    |> Date.from_iso8601()
    |> case do
      {:ok, date} -> {:ok, date}
      _error -> :error
    end
  end

  defp parse_date(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}
  defp parse_date(_), do: :error
end
