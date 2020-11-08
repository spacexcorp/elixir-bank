defmodule ElixirBank.Repo.Migrations.AddCategoryToRecords do
  use Ecto.Migration

  def change do
    alter table(:records) do
      add(:category, :string, null: false)
    end
  end
end
