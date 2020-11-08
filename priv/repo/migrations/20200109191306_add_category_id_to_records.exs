defmodule ElixirBank.Repo.Migrations.AddCategoryIdToRecords do
  use Ecto.Migration

  def up do
    alter table(:records) do
      remove(:category)
      add(:category_id, references(:categories, type: :binary_id), null: false)
    end
  end

  def down do
    alter table(:records) do
      remove(:category_id)
      add(:category, :string, null: false)
    end
  end
end
