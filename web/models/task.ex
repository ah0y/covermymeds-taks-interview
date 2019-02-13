defmodule PhoenixTasks.Task do
  use PhoenixTasks.Web, :model

  schema "tasks" do
    field :task_name, :string

    belongs_to :projects, PhoenixTasks.Project, foreign_key: :project_id
    belongs_to :users, PhoenixTasks.User, foreign_key: :user_id
    has_many :entries, PhoenixTasks.Entry

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:task_name])
    |> validate_required([:task_name])
  end
end
