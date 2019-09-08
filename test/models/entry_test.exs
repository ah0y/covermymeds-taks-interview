defmodule PhoenixTasks.EntryTest do
  use PhoenixTasks.ModelCase

  alias PhoenixTasks.Entry

  @valid_attrs %{note: "some note"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Entry.changeset(%Entry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Entry.changeset(%Entry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
