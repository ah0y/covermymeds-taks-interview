defmodule PhoenixTasks.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :project_name, :string
      add :customer_id, references(:customers)

      timestamps()
    end
  end
end
