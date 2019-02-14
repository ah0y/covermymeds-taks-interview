defmodule PhoenixTasks.UserController do
  use PhoenixTasks.Web, :controller
  #  plug :authenticate_user when action in [:index, :show]
  alias PhoenixTasks.User

  def authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
        |> put_flash(:error, "You must be logged in to access that page")
        |> redirect(to: user_path(conn, :new))
        |> halt()
    end
  end

  def pref(conn, _params) do

    render(conn, "pref.html")
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: session_path(conn, :new))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    {:ok, _user} = PhoenixTasks.delete_user(user)
    conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: user_path(conn, :index))
  end
end





