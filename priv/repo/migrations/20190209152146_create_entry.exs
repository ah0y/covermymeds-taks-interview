defmodule PhoenixTasks.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :note, :string
      add :task_id, references(:tasks)
      add :duration, :time
      add :start_time, :naive_datetime

      timestamps()
    end
  end
end
