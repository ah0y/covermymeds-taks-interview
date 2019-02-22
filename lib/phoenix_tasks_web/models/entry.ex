defmodule PhoenixTasks.Entry do
  use PhoenixTasks.Web, :model

  schema "entries" do
    field :note, :string
    field :start_time, :naive_datetime
    field :duration, :time

    belongs_to :task, PhoenixTasks.Task, foreign_key: :task_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:note, :start_time, :duration])
    |> validate_required([:start_time, :duration])
  end
end
