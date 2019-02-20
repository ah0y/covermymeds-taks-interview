defmodule PhoenixTasksWeb.Router do
  use PhoenixTasks.Web, :router
  use Coherence.Router         # Add this


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session  # Add this
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  # Add this block
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", PhoenixTasksWeb do
    pipe_through :browser # Use the default browser stack

    get "/",  PageController, :index

  end

  scope "/", PhoenixTasksWeb do
    pipe_through :protected

    get "/all", TaskController, :all
    get "/pref", UserController, :pref

    resources "/customers", CustomerController do
      resources "/projects", ProjectController do
        resources "/tasks", TaskController do
          resources "/entries", EntryController  do
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


