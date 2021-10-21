import Config

config :strava_gear_data, :api,
  client_id: System.get_env("STRAVA_CLIENT_ID"),
  client_secret: System.get_env("STRAVA_CLIENT_SECRET")

config :strava_gear_data, :super_secure_password, System.get_env("SUPER_SECURE_PASSWORD")
