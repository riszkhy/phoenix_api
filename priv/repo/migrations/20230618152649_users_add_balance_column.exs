defmodule PhoenixApi.Repo.Migrations.UsersAddBalanceColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :balance, :decimal, default: 0
    end
  end
end
