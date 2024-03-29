defmodule PhoenixTasks.TaskTest do
  use PhoenixTasks.ModelCase

  alias PhoenixTasks.Task

  @valid_attrs %{task_name: "some task_name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end
end
