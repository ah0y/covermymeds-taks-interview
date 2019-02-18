defmodule PhoenixTasks.Project do
  use PhoenixTasks.Web, :model

  schema "projects" do
    field :project_name, :string

    belongs_to :customers, PhoenixTasks.Customer, foreign_key: :customer_id
    has_many :tasks, PhoenixTasks.Task

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:project_name])
    |> validate_required([:project_name])
  end
end
