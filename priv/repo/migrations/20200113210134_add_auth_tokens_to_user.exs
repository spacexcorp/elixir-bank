defmodule ElixirBank.Repo.Migrations.AddAuthTokensToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:auth_tokens, {:array, :string}, default: [], null: false)
    end
  end
end
