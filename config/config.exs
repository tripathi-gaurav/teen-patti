# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :teenpatti, TeenpattiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rZe5Vzg5EDxb8ShbLTmLpfzo3lCJQwmq4T8s7VvZdYTZ8e/SymoGfV8tT63s5WK5",
  render_errors: [view: TeenpattiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Teenpatti.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
