defmodule PhoenixTasks.Customer do
  use PhoenixTasks.Web, :model

  schema "customers" do
    field :company, :string
    field :address1, :string
    field :address2, :string
    field :address3, :string
    field :city, :string
    field :state, :string
    field :zip, :integer
    field :phone1, :string
    field :phone2, :string
    field :fax1, :string
    field :fax2, :string
    field :email, :string
    field :website, :string

    has_many :projects, PhoenixTasks.Project
    has_many :tasks, through: [:projects, :tasks]
    has_many :entries, through: [:tasks, :entries]



    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:company, :address1, :address2, :address3, :city, :state, :zip, :phone1, :phone2, :fax1, :fax2, :email, :website])
    |> unique_constraint(:company)
    |> validate_required([:company, :address1, :city, :state, :zip, :phone1])
  end
end
