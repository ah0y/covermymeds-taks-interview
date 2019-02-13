defmodule PhoenixTasks.CustomerController do
  use PhoenixTasks.Web, :controller

  plug :authenticate_user when action in [:index, :new, :create, :show, :edit, :update, :delete]

  alias PhoenixTasks.Customer

  def index(conn, _params) do
    customers = Repo.all(Customer)
    render(conn, "index.html", customers: customers)
  end

  def new(conn, _params) do
    changeset = Customer.changeset(%Customer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"customer" => customer_params}) do
    changeset = Customer.changeset(%Customer{}, customer_params)
    case Repo.insert(changeset) do
      {:ok, customer} ->
        conn
        |> put_flash(:info, "Customer created successfully.")
        |> redirect(to: customer_path(conn, :show, customer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => customer}) do
    customer =
      Customer
      |> Repo.get(customer)
      |> Repo.preload(:projects)
    redirect(conn, to: customer_project_path(conn, :index, customer.id, customer.projects))
  end

  def edit(conn, %{"id" => id}) do
    customer = Repo.get(Customer, id)
    changeset = Customer.changeset(customer)
    render(conn, "edit.html", customer: customer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Repo.get(PhoenixTasks.Customer, id)
    changeset = Customer.changeset(customer, customer_params)
    case Repo.update(changeset) do
      {:ok, customer} ->
        conn
        |> put_flash(:info, "Customer updated successfully.")
        |> redirect(to: customer_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", customer: customer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Repo.get(Customer, id)
    Repo.delete!(customer)
    conn
    |> put_flash(:info, "Customer deleted successfully.")
    |> redirect(to: customer_path(conn, :index))
  end
end
