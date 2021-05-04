defmodule StravaGearData.Authorization do
  @moduledoc """
  Authorization business logic.

  Handles gathering data from Strava API then marshalling it into our expected
  forms
  """
  alias StravaGearData.Api
  alias StravaGearData.Athletes
  alias StravaGearData.Athletes.Athlete

  defdelegate authorize_url!, to: Api.Auth

  @spec authorize_athlete_from!(code: binary()) ::
          {:ok, Athletes.Athlete.t()} | {:error, Ecto.Changeset.t()}
  def authorize_athlete_from!(params) do
    api_token = Api.exchange_code_for_token(params)

    api_token
    |> build_athlete_attrs()
    |> insert_or_update_athlete()
  end

  @doc false
  def insert_or_update_athlete(athlete_attrs) do
    athlete_attrs.strava_id
    |> Athletes.get_athlete_by_strava_id()
    |> StravaGearData.Repo.preload([:access_token, :refresh_token])
    |> case do
      %Athlete{} = athlete -> Athletes.update_athlete(athlete, athlete_attrs)
      nil -> Athletes.create_athlete(athlete_attrs)
    end
  end

  @doc false
  def build_athlete_attrs(%{other_params: %{athlete: api_athlete}} = api_token) do
    %{
      strava_id: api_athlete.id,
      first_name: api_athlete.firstname,
      last_name: api_athlete.lastname,
      username: api_athlete.username,
      profile_picture: api_athlete.profile_medium
    }
    |> put_access_token_attrs(api_token)
    |> put_refresh_token_attrs(api_token)
  end

  @doc false
  def put_access_token_attrs(athlete_attrs, api_token) do
    %{access_token: access_token, expires_at: expires_at, token_type: token_type} = api_token

    Map.put(athlete_attrs, :access_token, %{
      token: access_token,
      expires_at: DateTime.from_unix!(expires_at),
      token_type: token_type
    })
  end

  @doc false
  def put_refresh_token_attrs(athlete_attrs, %{refresh_token: refresh_token}) do
    Map.put(athlete_attrs, :refresh_token, %{
      token: refresh_token
    })
  end
end
