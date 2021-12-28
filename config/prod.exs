import Config

config :strava_gear_data, :env, :prod

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :strava_gear_data, StravaGearDataWeb.Endpoint,
  # Possibly not needed, but doesn't hurt
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  http: [port: {:system, "PORT"}],
  url: [host: "strava.samuelwillis.dev", port: 443],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: [
    "//strava.samuelwillis.dev",
    "//strava-gear-data.gigalixirapp.com/"
  ]

config :strava_gear_data, StravaGearData.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  ssl: true,
  pool_size: 2

# Do not print debug messages in production
config :logger, level: :info

config :strava_gear_data, :redirect_uri, "http://localhost:4000/api/auth/callback"

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :strava_gear_data, StravaGearDataWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :strava_gear_data, StravaGearDataWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
import_config "prod.secret.exs"
