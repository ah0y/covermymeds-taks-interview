defmodule PhoenixTasks.ProjectTest do
  use PhoenixTasks.ModelCase

  alias PhoenixTasks.Project

  @valid_attrs %{project_name: "some project_name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
