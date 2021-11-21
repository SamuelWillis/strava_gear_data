defmodule StravaGearData.Api do
  @moduledoc """
  Public interface that allows interactions with the Strava Api.
  """

  alias StravaGearData.Api
  alias StravaGearData.Athletes

  @client Application.compile_env(:strava_gear_data, :strava_api, StravaGearData.Api.Client)

  @doc """
  Exchange the authorization code for the token and authenticated athlete.
  """
  @spec exchange_code_for_token(code: binary()) :: Api.Token.t()
  def exchange_code_for_token(params) do
    client().exchange_code_for_token(params)
  end

  @spec get_athlete(Athletes.Athlete.t()) :: Api.Athlete.t()
  def get_athlete(athlete) do
    client().get_athlete(athlete)
  end

  @spec get_activities_for(Athletes.Athlete.t(), keyword()) :: [Api.Activity.t()]
  def get_activities_for(athlete, opts \\ []) do
    client().get_activities_for(athlete, opts)
  end

  defp client(), do: @client
end
