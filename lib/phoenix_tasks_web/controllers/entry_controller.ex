defmodule PhoenixTasksWeb.EntryController do
  use PhoenixTasks.Web, :controller

  import Ecto.Query

  alias PhoenixTasks.Task
  alias PhoenixTasks.Entry
  alias PhoenixTasks.Coherence.User

  def index(conn, _params, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    query = from e in Entry,
                 join: t in Task,
                 where: t.id == e.task_id,
                 join: u in User,
                 where: u.id == t.user_id,
                 where: e.task_id == ^task
    entries = Repo.all(query)
    render(conn, "index.html", customer: customer, project: project, task: task, entries: entries)
  end

  def new(conn, params, _user) do
    changeset = Entry.changeset(%Entry{})
    render(
      conn,
      "new.html",
      customer: params["customer_id"],
      project: params["project_id"],
      task: params["task_id"],
      changeset: changeset,
    )
  end

  def create(conn, %{"entry" => entry_params}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    changeset = Repo.get(Task, conn.params["task_id"])
                |> build_assoc(:entries)
                |> Entry.changeset(entry_params)
    case Repo.insert(changeset) do
      {:ok, entry} ->
        conn
        |> put_flash(:info, "Entry created successfully.")
        |> render("show.html", customer: customer, project: project, task: task, entry: entry)
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
    entry = Repo.get(Entry, id)
    render(conn, "show.html", customer: customer, project: project, task: task, entry: entry)
  end

  def edit(conn, %{"id" => id}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    entry = Repo.get(Entry, id)
    changeset = Entry.changeset(entry)
    render(
      conn,
      "edit.html",
      customer: customer,
      project: project,
      task: task,
      entry: entry,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "entry" => entry_params}, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    entry = Repo.get(Entry, id)
    changeset = Entry.changeset(entry, entry_params)
    case Repo.update(changeset) do
      {:ok, _entry} ->
        conn
        |> put_flash(:info, "Task  entry updated successfully.")
        |> render(
             "index.html",
             customer: customer,
             project: project,
             task: task,
             entries: (Repo.all assoc(user, [:tasks, :entries]))
           )
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", entry: entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = conn.params["task_id"]
    entry = Repo.get(Entry, id)
    Repo.delete(entry)
    conn
    |> put_flash(:info, "Task entry deleted successfully.")
    |> render(
         "index.html",
         customer: customer,
         project: project,
         task: task,
         entries: (Repo.all assoc(user, [:tasks, :entries]))
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
