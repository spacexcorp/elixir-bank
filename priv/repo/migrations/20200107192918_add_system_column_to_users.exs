defmodule ElixirBank.Repo.Migrations.AddSystemColumnToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:system, :boolean, default: false)
    end

    create(unique_index(:users, :system, where: "system = true"))
  end
end
