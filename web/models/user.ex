defmodule PhoenixTasks.User do
  use PhoenixTasks.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash
    field :email, :string


    has_many :tasks, PhoenixTasks.Task


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ %{} ) do
    model
    |> cast(params, ~w(username email password), [])
    |> validate_required([:username, :email, :password])
    |> validate_length(:email, min: 1, max: 20)
    |> validate_length(:username, min: 1, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:username)
  end

  def registration_changeset(model, params \\ %{} ) do
    model
    |> changeset(params)
    |> validate_length(:password, min: 6, max: 100)
    |> cast(params, ~w(password), [])
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _->
        changeset
    end
  end
end
