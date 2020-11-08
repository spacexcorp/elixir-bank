defmodule ElixirBank.Records do
  alias Ecto.Multi
  alias ElixirBank.Records.Record
  alias ElixirBank.{Query, Repo}

  def list_records(category_name \\ nil) do
    Record
    |> Repo.all()
    |> Repo.preload([:category, :user_likes])
    |> Record.filter_by_category_name(category_name)
  end

  def list_most_liked_records(limit) do
    Record
    |> Query.sort_by(:likes, :desc)
    |> Query.limit_by(limit)
    |> Repo.all()
  end

  def get_record(record_id) do
    Record
    |> Repo.get(record_id)
    |> Repo.preload([:category, :user_likes])
    |> case do
      nil -> {:error, :record_does_not_exist}
      record = %Record{} -> {:ok, record}
    end
  end

  def create_record(attrs \\ %{}) do
    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert()
  end

  def update_record(record_id, attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:record, fn _, _ -> get_record(record_id) end)
    |> Multi.update(:updated_record, fn %{record: record = %Record{}} -> Record.changeset(record, attrs) end)
    |> Repo.transaction()
    |> case do
      {:ok, %{updated_record: updated_record = %Record{}}} -> {:ok, updated_record}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  def data, do: Dataloader.Ecto.new(Repo, query: &Query.default/2)
end
