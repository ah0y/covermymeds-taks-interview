defmodule PhoenixTasks.TaskEntryControllerTest do
  use PhoenixTasks.ConnCase

#  alias PhoenixTasks.PhoenixTasks

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:task_entry) do
    {:ok, task_entry} = PhoenixTasks.create_task_entry(@create_attrs)
    task_entry
  end

  describe "index" do
    test "lists all task_entries", %{conn: conn} do
      conn = get conn, task_entry_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Task entries"
    end
  end

  describe "new task_entry" do
    test "renders form", %{conn: conn} do
      conn = get conn, task_entry_path(conn, :new)
      assert html_response(conn, 200) =~ "New Task  entry"
    end
  end

  describe "create task_entry" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, task_entry_path(conn, :create), task_entry: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == task_entry_path(conn, :show, id)

      conn = get conn, task_entry_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Task  entry"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, task_entry_path(conn, :create), task_entry: @invalid_attrs
      assert html_response(conn, 200) =~ "New Task  entry"
    end
  end

  describe "edit task_entry" do
    setup [:create_task_entry]

    test "renders form for editing chosen task_entry", %{conn: conn, task_entry: task_entry} do
      conn = get conn, task_entry_path(conn, :edit, task_entry)
      assert html_response(conn, 200) =~ "Edit Task  entry"
    end
  end

  describe "update task_entry" do
    setup [:create_task_entry]

    test "redirects when data is valid", %{conn: conn, task_entry: task_entry} do
      conn = put conn, task_entry_path(conn, :update, task_entry), task_entry: @update_attrs
      assert redirected_to(conn) == task_entry_path(conn, :show, task_entry)

      conn = get conn, task_entry_path(conn, :show, task_entry)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, task_entry: task_entry} do
      conn = put conn, task_entry_path(conn, :update, task_entry), task_entry: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Task  entry"
    end
  end

  describe "delete task_entry" do
    setup [:create_task_entry]

    test "deletes chosen task_entry", %{conn: conn, task_entry: task_entry} do
      conn = delete conn, task_entry_path(conn, :delete, task_entry)
      assert redirected_to(conn) == task_entry_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, task_entry_path(conn, :show, task_entry)
      end
    end
  end

  defp create_task_entry(_) do
    task_entry = fixture(:task_entry)
    {:ok, task_entry: task_entry}
  end
end
