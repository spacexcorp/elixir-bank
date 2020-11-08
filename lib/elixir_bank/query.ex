defmodule ElixirBank.Query do
  import Ecto.Query

  def search(queriable, field, nil), do: from(element in queriable, where: element |> field(^field) |> is_nil())

  def search(queriable, field, value),
    do: from(element in queriable, where: field(element, ^field) == ^value)

  def sort_by(queriable, field, :asc), do: order_by(queriable, asc: ^field)
  def sort_by(queriable, field, :desc), do: order_by(queriable, desc: ^field)

  def limit_by(queriable, limit), do: limit(queriable, ^limit)

  def default(queriable, _), do: queriable
end
