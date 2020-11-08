defmodule ElixirBank.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:record_id, references(:records, type: :binary_id), null: false)
      add(:user_id, references(:users, type: :binary_id), null: false)

      timestamps()
    end

    create(unique_index(:likes, [:record_id, :user_id]))
  end
end
