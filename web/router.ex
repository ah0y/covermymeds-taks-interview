defmodule PhoenixTasks.Router do
  use PhoenixTasks.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PhoenixTasks.Auth, repo: PhoenixTasks.Repo

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixTasks do
    pipe_through :browser # Use the default browser stack

    get "/", SessionController, :new

    get "/index", PageController, :index

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/customers", CustomerController do
      resources "/projects", ProjectController do
        resources "/tasks", TaskController do
          resources "/task_entries", TaskEntryController  do
          end
        end
      end
    end




  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixTasks do
  #   pipe_through :api
  # end
end


