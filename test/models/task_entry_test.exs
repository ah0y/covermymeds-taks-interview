defmodule PhoenixTasks.TaskEntryTest do
  use PhoenixTasks.ModelCase

  alias PhoenixTasks.TaskEntry

  @valid_attrs %{note: "some note"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskEntry.changeset(%TaskEntry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskEntry.changeset(%TaskEntry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
