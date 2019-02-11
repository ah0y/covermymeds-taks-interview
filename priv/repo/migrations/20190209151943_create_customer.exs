defmodule PhoenixTasks.Repo.Migrations.CreateCustomer do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :company, :string
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :integer

      timestamps()
    end
  end
end
