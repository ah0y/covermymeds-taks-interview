defmodule PhoenixTasks.TaskEntryController do
  use PhoenixTasks.Web, :controller

  import Ecto.Query

  plug :authenticate_user when action in [:index, :new, :create, :show, :edit, :update, :delete]

  alias PhoenixTasks.Task
  alias PhoenixTasks.TaskEntry
  alias PhoenixTasks.User

  def index(conn, params, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    query = from te in TaskEntry,
                 join: t in Task,
                 where: t.id == te.task_id,
                 join: u in User,
                 where: u.id == t.user_id,
                 where: te.task_id == ^task
    task_entries = Repo.all(query)
    render(conn, "index.html", customer: customer, project: project, task: task, task_entries: task_entries)
  end

  def new(conn, params, _user) do
    changeset = TaskEntry.changeset(%TaskEntry{})
    render(
      conn,
      "new.html",
      customer: params["customer_id"],
      project: params["project_id"],
      task: params["task_id"],
      changeset: changeset,
    )
  end

  def create(conn, %{"task_entry" => task_entry_params}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    changeset = Repo.get(Task, conn.params["task_id"])
                |> build_assoc(:task_entries)
                |> TaskEntry.changeset(task_entry_params)
    case Repo.insert(changeset) do
      {:ok, task_entry} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> render("show.html", customer: customer, project: project, task: task, task_entry: task_entry.id)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          customer: customer,
          project: project,
          task: task,
          changeset: changeset
        )
    end
  end

  def show(conn, %{"id" => id}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    task_entry = Repo.get(TaskEntry, id)
    render(conn, "show.html", customer: customer, project: project, task: task, task_entry: task_entry)
  end

  def edit(conn, %{"id" => id}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    task_entry = Repo.get(TaskEntry, id)
    changeset = TaskEntry.changeset(task_entry)
    render(
      conn,
      "edit.html",
      customer: customer,
      project: project,
      task: task,
      task_entry: task_entry,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "task_entry" => task_entry_params}, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    task_entry = Repo.get(TaskEntry, id)
    changeset = TaskEntry.changeset(task_entry, task_entry_params)
    case Repo.update(changeset) do
      {:ok, task_entry} ->
        conn
        |> put_flash(:info, "Task  entry updated successfully.")
        |> render(
             "index.html",
             customer: customer,
             project: project,
             task: task,
             task_entries: (Repo.all assoc(user, [:tasks, :task_entries]))
           )
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task_entry: task_entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    task_entry = Repo.get(TaskEntry, id)
    Repo.delete(task_entry)
    conn
    |> put_flash(:info, "Task entry deleted successfully.")
    |> render(
         "index.html",
         customer: customer,
         project: project,
         task: task,
         task_entries: (Repo.all assoc(user, [:tasks, :task_entries]))
       )
  end

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, conn.assigns.current_user]
    )
  end
end
