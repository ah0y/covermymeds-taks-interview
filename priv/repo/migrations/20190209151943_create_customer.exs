defmodule PhoenixTasks.Repo.Migrations.CreateCustomer do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :company, :string
      add :address1, :string
      add :address2, :string
      add :address3, :string

      add :city, :string
      add :state, :string
      add :zip, :integer
      add :phone1, :string
      add :phone2, :string
      add :fax1, :string
      add :fax2, :string
      add :email, :string
      add :website, :string

      timestamps()
    end
  end
end
