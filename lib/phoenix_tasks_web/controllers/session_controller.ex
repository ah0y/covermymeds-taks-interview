defmodule PhoenixTasksWeb.SessionController do
  use PhoenixTasks.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(
        conn,
        %{
          "session" => %{
            "username" => user,
            "password" => pass
          }
        }
      ) do
    case PhoenixTasksWeb.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
          |> put_flash(:info, "Welcome back!")
          |> redirect(to: task_path(conn, :all))
      {:error, _reason, conn} ->
        conn
          |> put_flash(:error, "Invalid username/password combination")
          |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
      |> PhoenixTasksWeb.Auth.logout()
      |> redirect(to: session_path(conn, :new))
  end
end


