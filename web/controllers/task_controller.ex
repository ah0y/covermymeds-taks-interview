defmodule PhoenixTasks.TaskController do
  use PhoenixTasks.Web, :controller

  import Ecto.Query

  plug :authenticate_user when action in [:index, :new, :create, :show, :edit, :update, :delete, :all]

  alias PhoenixTasks.Customer
  alias PhoenixTasks.Project
  alias PhoenixTasks.Task
  alias PhoenixTasks.TaskEntry
  alias PhoenixTasks.User

  def index(conn, params, user) do
    customer = params["customer_id"]
    project = Repo.get(Project, params["project_id"])
    query = from(t in Task, where: t.project_id == ^project.id)
    user =
      user
      |> Repo.preload(tasks: query)
    render(conn, "index.html", header: project.project_name, customer: customer, project: project.id, tasks: user.tasks)
  end

  def all(conn, params, user) do
    user = Repo.all assoc(user, [:tasks, :projects, :customers])
    work = Repo.preload(user, [{:projects, :tasks}])
    render(conn, "all.html", work: work)
  end

  def new(conn, params, _user) do
    customer = params["customer_id"]
    project = params["project_id"]
    changeset = Task.changeset(%Task{})
    render(conn, "new.html", changeset: changeset, customer: customer, project: project)
  end

  def create(conn, %{"task" => task_params}, user) do
    customer = conn.params["customer_id"]
    changeset = Repo.get(Project, conn.params["project_id"])
                |> build_assoc(:tasks)
                |> Ecto.Changeset.change()
                |> Ecto.Changeset.put_assoc(:users, user)

    changeset = Task.changeset(changeset, task_params)
    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: customer_project_task_path(conn, :show, customer, task.project_id, task.user_id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => task}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    redirect(conn, to: customer_project_task_task_entry_path(conn, :index, customer, project, task))
  end

  def edit(conn, %{"id" => id}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = Repo.get(Task, id)
    changeset = Task.changeset(task)
    render(
      conn,
      "edit.html",
      customer: customer,
      project: project,
      task: task,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "task" => task_params}, user) do
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]
    task = Repo.get(Task, id)
    query = from(t in Task, where: t.project_id == ^project)
    user =
      user
      |> Repo.preload(tasks: query)
    changeset = Task.changeset(task, task_params)
    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: customer_project_task_path(conn, :index, customer, project, user.tasks))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    customer = conn.params["customer_id"]
    project = conn.params["customer_id"]
    task = Repo.get(Task, id)
    Repo.delete(task)
    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: customer_project_task_path(conn, :index, customer, project))
  end

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, conn.assigns.current_user]
    )
  end
end
