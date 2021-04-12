defmodule StravaGearData.Repo do
  use Ecto.Repo,
    otp_app: :strava_gear_data,
    adapter: Ecto.Adapters.Postgres
end
