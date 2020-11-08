defmodule ElixirBank.Repo.Migrations.AddPinToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:pin, :string, null: false)
    end
  end
end
