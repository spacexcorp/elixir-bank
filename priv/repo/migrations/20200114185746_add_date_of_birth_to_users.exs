defmodule ElixirBank.Repo.Migrations.AddDateOfBirthToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:date_of_birth, :date, null: false)
    end
  end
end
