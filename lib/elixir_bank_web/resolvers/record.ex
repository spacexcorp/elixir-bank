defmodule ElixirBankWeb.Resolvers.Record do
  alias Ecto.Changeset
  alias ElixirBank.{Interactions, Records}
  alias ElixirBank.Records.Record

  def all_records(attrs, _info) do
    category_name = get_category_name(attrs)
    records = Records.list_records(category_name)
    {:ok, records}
  end

  defp get_category_name(%{category_name: category_name}), do: category_name |> Atom.to_string() |> String.capitalize()
  defp get_category_name(_), do: nil

  def most_liked_records(%{limit: limit}, _info) do
    most_liked_records = Records.list_most_liked_records(limit)
    {:ok, most_liked_records}
  end

  def get_record(%{id: id}, _info) do
    id
    |> Records.get_record()
    |> case do
      {:ok, record = %Record{}} -> {:ok, record}
      {:error, :record_does_not_exist} -> {:error, "record does not exist"}
    end
  end

  def create_record(args, _info) do
    args
    |> Records.create_record()
    |> case do
      {:ok, record = %Record{}} -> {:ok, record}
      {:error, %Changeset{}} -> {:error, "could not create record"}
    end
  end

  def update_record(%{id: id, params: params}, _info) do
    id
    |> Records.update_record(params)
    |> case do
      {:ok, record = %Record{}} -> {:ok, record}
      {:error, _} -> {:error, "could not update record"}
    end
  end

  def toggle_like(%{record_id: record_id}, _info) do
    record_id
    |> Interactions.toggle_like()
    |> case do
      {:ok, record = %Record{}} -> {:ok, record}
      {:error, _} -> {:error, "could not toggle like"}
    end
  end
end
