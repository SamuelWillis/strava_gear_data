defmodule StravaGearData.Api.Client do
  @moduledoc false

  alias StravaGearData.Api
  alias StravaGearData.Athletes
  alias StravaGearData.Authorization

  @doc """
  Exchange the authorization code for the token and authenticated athlete.
  """
  @callback exchange_code_for_token(code: binary()) :: Api.Token.t()
  def exchange_code_for_token(params) do
    params
    |> Api.Auth.get_token!()
    |> Map.fetch!(:token)
    |> Api.Token.from!()
  end

  @callback get_athlete(Athletes.Athlete.t()) :: Api.Athlete.t()
  def get_athlete(athlete) do
    athlete
    |> build_client()
    |> Api.Auth.get!("/athlete", [], [])
    |> Map.fetch!(:body)
    |> Api.Athlete.from!()
  end

  @callback get_activities_for(Athletes.Athlete.t(), page: integer()) :: [Api.Activity.t()]
  def get_activities_for(athlete, opts \\ []) do
    page = Keyword.get(opts, :page, 1)

    client_opts = [params: %{page: page, per_page: 50}]

    athlete
    |> build_client()
    |> Api.Auth.get!("/athlete/activities", [], client_opts)
    |> Map.fetch!(:body)
    |> Enum.map(&Api.Activity.from!/1)
  end

  defp build_client(athlete) do
    athlete = Athletes.preload_tokens(athlete)

    expires_in = DateTime.diff(athlete.access_token.expires_at, DateTime.utc_now())

    token =
      Api.Auth.access_token(%{
        "access_token" => athlete.access_token.token,
        "expires_in" => expires_in,
        "refresh_token" => athlete.refresh_token.token
      })

    client = Api.Auth.client(token: token)

    case Api.Auth.expired?(token) do
      true ->
        client = Api.Auth.refresh_tokens!(client)

        client
        |> Map.fetch!(:token)
        |> Api.Token.from!()
        |> then(&Authorization.update_athlete_tokens(athlete, &1))

        client

      _ ->
        client
    end
  end
end
