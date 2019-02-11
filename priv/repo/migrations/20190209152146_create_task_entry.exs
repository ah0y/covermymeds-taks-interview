defmodule PhoenixTasks.Repo.Migrations.CreateTaskEntry do
  use Ecto.Migration

  def change do
    create table(:task_entries) do
      add :note, :string
      add :task_id, references(:tasks)

      timestamps()
    end
  end
end
