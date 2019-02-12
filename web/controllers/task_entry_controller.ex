defmodule PhoenixTasks.TaskEntryController do
  use PhoenixTasks.Web, :controller
  import Ecto.Query
  plug :authenticate_user when action in [:index, :new, :create, :show, :edit, :update, :delete]


  alias PhoenixTasks.TaskEntry
  alias PhoenixTasks.Task
  alias PhoenixTasks.User

  def index(conn, params, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    query = from te in TaskEntry,
            join: t in Task, where: t.id == te.task_id,
            join: u in User, where: u.id == t.user_id,
            where: te.task_id == ^task
    task_entries = Repo.all(query)
    render(conn, "index.html", task_entries: task_entries, customer: customer, project: project, task: task)
  end

  def new(conn, params, user) do
    changeset = TaskEntry.changeset(%TaskEntry{})
    render(conn, "new.html", changeset: changeset, customer: params["customer_id"], project: params["project_id"], task: params["task_id"])
  end

  def create(conn, %{"task_entry" => task_entry_params}, user) do
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
        render(conn, "new.html", changeset: changeset, customer: conn.params["customer_id"], project: conn.params["project_id"], task: conn.params["task_id"])
    end
  end

  def show(conn, %{"id" => id}, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    task_entry = Repo.get(TaskEntry, id)
    render(conn, "show.html",  task_entry: task_entry, customer: customer, project: project, task: task)
  end

  def edit(conn, %{"id" => id}, user) do
    task_entry = Repo.get(TaskEntry, id)
    changeset = TaskEntry.changeset(task_entry)
    render(conn, "edit.html", task_entry: task_entry, task: conn.params["task_id"], changeset: changeset, customer: conn.params["customer_id"], project: conn.params["project_id"])
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
        |> render( "index.html", task_entries: (Repo.all assoc(user, [:tasks, :task_entries])), customer: customer, project: project, task: task)
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
      |> render( "index.html", task_entries: (Repo.all assoc(user, [:tasks, :task_entries])), customer: customer, project: project, task: task)
  end


  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end
end
