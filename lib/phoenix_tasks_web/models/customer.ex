defmodule PhoenixTasks.Customer do
  use PhoenixTasks.Web, :model

  schema "customers" do
    field :company, :string
    field :address, :string
    field :city, :string
    field :state, :string
    field :zip, :integer

    has_many :projects, PhoenixTasks.Project


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:company, :address, :city, :state, :zip])
    |> validate_required([:company, :address, :city, :state, :zip])
  end
end
