defmodule StravaGearData.Api do
  @moduledoc """
  Public interface that allows interactions with the Strava Api.
  """

  alias StravaGearData.Api

  @doc """
  Exchange the authorization code for the token and authenticated athlete.
  """
  @spec exchange_code_for_token(code: binary()) :: Api.Token.t()
  def exchange_code_for_token(params) do
    params
    |> Api.Auth.get_token!()
    |> Map.fetch!(:token)
    |> Api.Token.from!()
  end
end
