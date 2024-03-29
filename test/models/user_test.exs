defmodule PhoenixTasks.UserTest do
  use PhoenixTasks.ModelCase

  alias PhoenixTasks.Coherence.User

  @valid_attrs %{email: "some email", password: "some password", username: "some username"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
