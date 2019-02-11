defmodule PhoenixTasks.TaskEntryController do
  use PhoenixTasks.Web, :controller

  alias PhoenixTasks.TaskEntry

  def index(conn, _params) do
    task_entries = Repo.all(TaskEntry)
    render(conn, "index.html", task_entries: task_entries)
  end

  def new(conn, _params) do
    changeset = PhoenixTasks.change_task_entry(%TaskEntry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task_entry" => task_entry_params}) do
    changeset = PhoenixTasks.change_task_entry(%TaskEntry{}, task_entry_params)
    case PhoenixTasks.create_task_entry(changeset) do
      {:ok, task_entry} ->
        conn
        |> put_flash(:info, "Task  entry created successfully.")
#        |> redirect(to: customer_project_task_task_entry(conn, :show, task_entry))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task_entry = Repo.get(PhoenixTasks.TaskEntry, id)
    render(conn, "show.html", task_entry: task_entry)
  end

  def edit(conn, %{"id" => id}) do
    task_entry = Repo.get(PhoenixTasks.TaskEntry, id)
    changeset = TaskEntry.changeset(task_entry)
    render(conn, "edit.html", task_entry: task_entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task_entry" => task_entry_params}) do
    task_entry = Repo.get(PhoenixTasks.TaskEntry, id)
    changeset = TaskEntry.changeset(task_entry, task_entry_params)

    case Repo.update(changeset) do
      {:ok, task_entry} ->
        conn
        |> put_flash(:info, "Task  entry updated successfully.")
#        |> redirect(to: customer_project_task_task_entry(conn, :show, task_entry))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task_entry: task_entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task_entry = Repo.get(TaskEntry, id)
    {:ok, _task_entry} = PhoenixTasks.delete_task_entry(task_entry)

    conn
    |> put_flash(:info, "Task  entry deleted successfully.")
#    |> redirect(to: customer_project_task_task_entry(conn, :index))
  end
end
