defmodule PhoenixTasksWeb.CsvController do
  use PhoenixTasks.Web, :controller
  alias PhoenixTasks.Customer
  alias PhoenixTasks.Project
  alias PhoenixTasks.Task
  alias PhoenixTasks.Entry
  alias PhoenixTasks.Coherence.User


  def index(conn, _params) do

    render(conn, "index.html")
  end

  def import(conn, params) do
    params["csv"].path
    |> File.stream!()
    |> CSV.decode
    |> Enum.each(
         fn (company) ->
           Enum.zip(
             [
               :company,
               :address1,
               :address2,
               :address3,
               :city,
               :state,
               :zip,
               :phone1,
               :phone2,
               :fax1,
               :fax2,
               :email,
               :website
             ],
             company
           )
           |> Enum.into(%{})
           |> try_and_insert
         end
       )
    conn
    |> put_flash(:info, "Imported")
    |> redirect(to: customer_path(conn, :index))
  end

  defp try_and_insert(changeset) do
    PhoenixTasks.Repo.insert(Customer.changeset(%Customer{}, changeset))
    |> case do
         {:ok, customer} -> IO.puts "inserted"
         _ ->
           IO.inspect changeset
       end
  end

  #report by user
  def export(conn, _params) do
    query = from(
      t in Task,
      join: u in User,
      where: t.user_id == u.id,
      join: e in Entry,
      where: e.task_id == t.id,
      group_by: t.id,
      select: %{
        t |
        total_time: sum(e.duration)
      }
    )

    tasks = Repo.all(query)
    tasks = Repo.preload(tasks, :users)
    csv = List.foldl(
      tasks,
      [],
      fn task, acc ->
        [
          [task.users.name, task.task_name, task.total_time.secs] | acc
        ]
      end
    )

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"A Real CSV.csv\"")
    |> send_resp(200, csv_content(csv))
  end

  defp csv_content(report) do
    csv_content = report

                  |> CSV.encode
                  |> Enum.to_list
                  |> to_string
  end
end


