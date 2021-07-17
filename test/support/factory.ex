defmodule StravaGearData.Factory do
  @moduledoc """
  StravaGearData factories.
  """
  use ExMachina.Ecto, repo: StravaGearData.Repo

  def athlete_factory() do
    %StravaGearData.Athletes.Athlete{
      strava_id: sequence(:strava_id, & &1, start_at: 1)
    }
  end

  def with_profile(athlete) do
    %{
      athlete
      | first_name: "Test",
        last_name: "Athlete",
        username: "testathlete",
        profile_picture: "https://profile.picture/of/athlete"
    }
  end

  def with_access_token(athlete) do
    %{
      athlete
      | access_token: build(:access_token, athlete: nil)
    }
  end

  def with_refresh_token(athlete) do
    %{
      athlete
      | refresh_token: build(:refresh_token, athlete: nil)
    }
  end

  def with_tokens(athlete) do
    athlete
    |> with_access_token()
    |> with_refresh_token()
  end

  def with_gear(athlete, count \\ 1) do
    %{athlete | gear: build_list(count, :gear, athlete: nil)}
  end

  def gear_factory() do
    %StravaGearData.Gear.Gear{
      athlete: build(:athlete),
      strava_id: sequence("strava_gear_id"),
      name: sequence("gear_name"),
      primary: false
    }
  end

  def access_token_factory() do
    %StravaGearData.Athletes.AccessToken{
      athlete: build(:athlete),
      token: "fake-token",
      token_type: "Bearer",
      expires_at: DateTime.truncate(DateTime.utc_now(), :second)
    }
  end

  def refresh_token_factory() do
    %StravaGearData.Athletes.RefreshToken{
      athlete: build(:athlete),
      token: "fake-token"
    }
  end

  def api_athlete_factory() do
    %StravaGearData.Api.Athlete{
      id: 1234,
      firstname: "Api",
      lastname: "Athlete",
      username: "api_athlete",
      profile_medium: "https://profile.picture/of/athlete"
    }
  end

  def with_shoes(api_athlete, count \\ 1) do
    %{api_athlete | shoes: build_list(count, :api_gear)}
  end

  def with_bikes(api_athlete, count \\ 1) do
    %{api_athlete | bikes: build_list(count, :api_gear)}
  end

  def api_gear_factory() do
    %{
      id: sequence("gear_id"),
      name: sequence("gear_name"),
      primary: false,
      distance: 0 + :rand.uniform() * (10_000 - 0)
    }
  end
end
