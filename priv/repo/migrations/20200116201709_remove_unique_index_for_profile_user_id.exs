defmodule ElixirBank.Repo.Migrations.RemoveUniqueIndexForProfileUserId do
  use Ecto.Migration

  def change do
    drop(unique_index(:profiles, :user_id))
  end
end
