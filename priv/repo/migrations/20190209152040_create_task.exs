defmodule PhoenixTasks.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :task_name, :string
      add :user_id, references(:users)
      add :project_id, references(:projects)

      timestamps()
    end
  end
end
