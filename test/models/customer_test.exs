defmodule PhoenixTasks.CustomerTest do
  use PhoenixTasks.ModelCase

  alias PhoenixTasks.Customer

  @valid_attrs %{address: "some address", city: "some city", company: "some company", state: "some state", zip: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Customer.changeset(%Customer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Customer.changeset(%Customer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
