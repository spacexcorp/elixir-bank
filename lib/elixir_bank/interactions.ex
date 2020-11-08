defmodule ElixirBank.Interactions do
  alias Ecto.Multi
  alias Ecto.Schema.Metadata
  alias ElixirBank.Accounts.User
  alias ElixirBank.Interactions.Like
  alias ElixirBank.Records.Record
  alias ElixirBank.{Accounts, Query, Records, Repo}

  def toggle_like(record_id) do
    Multi.new()
    |> Multi.run(:record, fn _, _ -> Records.get_record(record_id) end)
    |> Multi.run(:user, fn _, _ -> Accounts.get_system_user() end)
    |> Multi.run(:like, fn _, %{user: %User{id: user_id}} -> get_like(record_id, user_id) end)
    |> Multi.run(:liked_record, fn _, %{like: like = %Like{}, record: record = %Record{}} ->
      update_record_likes(like, record.id)
      Records.get_record(record.id)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{liked_record: liked_record = %Record{}}} -> {:ok, liked_record}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  defp get_like(record_id, user_id) do
    Like
    |> Repo.get_by(%{record_id: record_id, user_id: user_id})
    |> create_or_delete_like(record_id, user_id)
  end

  defp create_or_delete_like(nil, record_id, user_id), do: Repo.insert(%Like{record_id: record_id, user_id: user_id})
  defp create_or_delete_like(like = %Like{}, _, _), do: Repo.delete(like)

  defp update_record_likes(%Like{__meta__: %Metadata{state: :deleted}}, record_id),
    do: Record |> Query.search(:id, record_id) |> Repo.update_all(inc: [likes: -1])

  defp update_record_likes(%Like{__meta__: %Metadata{state: :loaded}}, record_id),
    do: Record |> Query.search(:id, record_id) |> Repo.update_all(inc: [likes: 1])
end
