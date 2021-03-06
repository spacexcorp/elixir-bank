defmodule ElixirBank.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, type: :binary_id), null: false)

      timestamps()
    end

    create(unique_index(:profiles, :user_id))
  end
end
