defmodule StravaGearData.Api do
  @moduledoc """
  Public interface that allows interactions with the Strava Api.
  """

  alias StravaGearData.Api

  defdelegate authorize_url!, to: Api.Auth

  defdelegate get_token!(params), to: Api.Auth
end
