defmodule PhoenixTasks.TaskController do
  use PhoenixTasks.Web, :controller

  alias PhoenixTasks.Task
  alias PhoenixTasks.Project
  alias PhoenixTasks.User

  def index(conn, params, user) do
    tasks = Repo.all(Task)
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, params, user) do
    changeset = Task.changeset(%Task{})
    render(conn, "new.html", changeset: changeset, customer: params["customer_id"], project: params["project_id"])
  end

  def create(conn, %{"task" => task_params}, user) do
    require IEx; IEx.pry()
    project = Repo.get(Project, conn.params["project_id"])
    changeset = Repo.get(Project, conn.params["project_id"])
                |> build_assoc(:tasks)
                |> Task.changeset(task_params)
    changeset = Task.changeset(%Task{}, task_params)
    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    task = Repo.get(Task, id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}, user) do
    task = Repo.get(Task, id)
    changeset = Task.changeset(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}, user) do
    task = Repo.get(Task, id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
#        |> redirect(to: customer_project_task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    task = Repo.get(Task, id)
    {:ok, _task} = PhoenixTasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
#    |> redirect(to: customer_project_task_path(conn, :index))
  end

    def action(conn, _) do
      apply(__MODULE__, action_name(conn),
        [conn, conn.params, conn.assigns.current_user])
    end
end
