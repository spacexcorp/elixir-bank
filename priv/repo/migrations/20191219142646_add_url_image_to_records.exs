defmodule ElixirBank.Repo.Migrations.AddUrlImageToRecords do
  use Ecto.Migration

  def change do
    alter table(:records) do
      add(:image_url, :string, null: false)
    end
  end
end
