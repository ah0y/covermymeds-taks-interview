defmodule PhoenixTasks.TaskController do
  use PhoenixTasks.Web, :controller
  import Ecto.Query
  plug :authenticate_user when action in [:index, :new, :create, :show, :edit, :update, :delete, :all]

  alias PhoenixTasks.Task
  alias PhoenixTasks.Project
  alias PhoenixTasks.User
  alias PhoenixTasks.TaskEntry
  alias PhoenixTasks.Customer


  def index(conn, params, user) do
    project = params["project_id"]
    query = from(t in Task, where: t.project_id == ^project)
    user =
    user |>
      Repo.preload(tasks: query)

  render(conn, "index.html", customer: params["customer_id"], project: project, tasks: user.tasks)
  end

  def all(conn, params, user) do
    user = Repo.all assoc(user, [:tasks, :projects, :customers])
    work = Repo.preload(user, [{:projects, :tasks}])


#    require IEx; IEx.pry()

    render(conn, "all.html", work: work)
  end

  def new(conn, params, user) do
    changeset = Task.changeset(%Task{})
    render(conn, "new.html", changeset: changeset, customer: params["customer_id"], project: params["project_id"])
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
#       gotta fix this render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => task}, user) do
    customer  = conn.params["customer_id"]
    project = conn.params["project_id"]
#    task_entries = Repo.get(Task, task)
#      |> Repo.preload(:task_entries)
#    require IEx; IEx.pry()
    redirect(conn, to: customer_project_task_task_entry_path(conn, :index, customer, project, task ))
  end

  def edit(conn, %{"id" => id}, user) do
    task = Repo.get(Task, id)
    changeset = Task.changeset(task)
    render(conn, "edit.html", task: task, changeset: changeset, customer: conn.params["customer_id"], project: conn.params["project_id"])
  end

  def update(conn, %{"id" => id, "task" => task_params}, user) do
    task = Repo.get(Task, id)
    changeset = Task.changeset(task, task_params)
    customer = conn.params["customer_id"]
    project = conn.params["project_id"]

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: customer_project_task_path(conn, :show, customer, project, task.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    customer = conn.params["customer_id"]
    project = conn.params["customer_id"]
    task = Repo.get(Task, id)
    Repo.delete(task)
    conn
      |> put_flash(:info, "Task deleted successfully.")
      |> redirect(to: customer_project_task_path(conn, :index, customer, project))
  end

    def action(conn, _) do
      apply(__MODULE__, action_name(conn),
        [conn, conn.params, conn.assigns.current_user])
    end
end
