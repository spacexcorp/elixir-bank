defmodule ElixirBank.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records, primary_key: false) do
      add(:description, :text, null: false)
      add(:id, :binary_id, primary_key: true)
      add(:title, :string, null: false)

      timestamps()
    end
  end
end
