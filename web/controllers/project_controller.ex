defmodule PhoenixTasks.ProjectController do
  use PhoenixTasks.Web, :controller

  alias PhoenixTasks.Customer
  alias PhoenixTasks.Project
  alias PhoenixTasks.Task
  alias PhoenixTasks.User

  def index(conn, _params, _user) do
    customer =
      Customer
      |> Repo.get(conn.params["customer_id"])
      |> Repo.preload(:projects)
    render(conn, "index.html", projects: customer.projects)
  end

  def new(conn, params, _user) do
    changeset = Project.changeset(%Project{})
    render(conn, "new.html", changeset: changeset, company: params["customer_id"])
  end

  def create(conn, %{"project" => project_params}, _user) do
    changeset = Repo.get(Customer, conn.params["customer_id"])
      |> build_assoc(:projects)
      |> Project.changeset(project_params)
    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: customer_project_path(conn, :show, project.customer_id, project.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    require IEx; IEx.pry()
    user
      |> Repo.preload(:tasks)
    redirect(conn, to: customer_project_task_path(conn, :index, conn.params["customer_id"], id, user.tasks))
  end

  def edit(conn, %{"id" => id}, _user) do
    project = Repo.get(Project, id)
    changeset = Project.changeset(project)
    render(conn, "edit.html", customer: conn.params["customer_id"], project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => project_params}, _user) do
    project = Repo.get(Project, id)
    changeset = Project.changeset(project, project_params)
    case Repo.update(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: customer_project_path(conn, :show, project.customer_id, project.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user) do
    customer =
      Customer
      |> Repo.get(conn.params["customer_id"])
      |> Repo.preload(:projects)
    project = Repo.get(Project, id)
    Repo.delete!(project)
    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: customer_project_path(conn, :index, customer.id, customer.projects))
  end

    def action(conn, _) do
      apply(__MODULE__, action_name(conn),
        [conn, conn.params, conn.assigns.current_user])
    end
end
