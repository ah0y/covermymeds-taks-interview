defmodule PhoenixTasks.Task do
  use PhoenixTasks.Web, :model

  alias PhoenixTasks.Entry

  schema "tasks" do
    field :task_name, :string
    field :total_time, :integer, virtual: true

    belongs_to :projects, PhoenixTasks.Project, foreign_key: :project_id
    belongs_to :users, PhoenixTasks.Coherence.User, foreign_key: :user_id
    has_many :entries, PhoenixTasks.Entry, on_delete: :delete_all

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

  def total_time(task) do
      from t in Task,
        join: e in Entry,
        where: e.task_id == t.id,
        select: %{t | total_time: sum(e.duration)}
  end
end
