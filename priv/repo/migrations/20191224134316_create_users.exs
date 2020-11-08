defmodule ElixirBank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:email, :string, null: false)
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)

      timestamps()
    end
  end
end
