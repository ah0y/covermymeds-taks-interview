defmodule PhoenixTasks.TaskController do
  use PhoenixTasks.Web, :controller

  alias PhoenixTasks.Task

  def index(conn, params) do
    require IEx; IEx.pry()
    tasks = Repo.all(Task)
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Task.changeset(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    changeset = Task.changeset(%Task{}, task_params)
    case Repo.insert(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
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
