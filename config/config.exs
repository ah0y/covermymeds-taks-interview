# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_tasks,
  ecto_repos: [PhoenixTasks.Repo]

# Configures the endpoint
config :phoenix_tasks, PhoenixTasksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "H8cQWU6b1Gc8GIIrMq0nN0pZI3/CDCXzZhEU6hOFzH5p9zABRe1Eq/zmlodEoVwW",
  render_errors: [view: PhoenixTasksWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhoenixTasks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: PhoenixTasks.Coherence.User,
  repo: PhoenixTasks.Repo,
  module: PhoenixTasks,
  web_module: PhoenixTasksWeb,
  router: PhoenixTasksWeb.Router,
  messages_backend: PhoenixTasksWeb.Coherence.Messages,
  logged_out_url: "/",
  registration_permitted_attributes: ["email","name","password","current_password","password_confirmation"],
  invitation_permitted_attributes: ["name","email"],
  password_reset_permitted_attributes: ["reset_password_token","password","password_confirmation"],
  session_permitted_attributes: ["remember","email","password"],
  email_from_name: "account support",
  email_from_email: "accounts@abesprojects.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :confirmable, :registerable]

config :coherence, PhoenixTasksWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: {:system, "SENDGRID_API_KEY"}
# %% End Coherence Configuration %%
