defmodule ElixirBank.Repo.Migrations.AddLikesToRecords do
  use Ecto.Migration

  def change do
    alter table(:records) do
      add(:likes, :integer, null: false, default: 0)
    end
  end
end
