# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :strava_gear_data,
  ecto_repos: [StravaGearData.Repo]

# Configures the endpoint
config :strava_gear_data, StravaGearDataWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c+Gmw07RNZbCQ07mUuGaGbUtC1WdLpUsR4SyRY+iyujmN8nDFenjT42Q4bjXTY50",
  render_errors: [view: StravaGearDataWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: StravaGearData.PubSub,
  live_view: [signing_salt: "dOq65F7F"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :strava_gear_data, :redirect_uri, "http://localhost:4000/api/auth/callback"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
