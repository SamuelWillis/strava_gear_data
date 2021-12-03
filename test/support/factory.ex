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

  def with_activities(athlete, count \\ 1) do
    %{athlete | activities: build_list(count, :activity, athlete: nil)}
  end

  def gear_factory() do
    %StravaGearData.Gear.Gear{
      athlete: build(:athlete),
      strava_id: sequence("strava_gear_id"),
      name: sequence("gear_name"),
      primary: false,
      activities: build_list(5, :activity)
    }
  end

  def activity_factory() do
    %StravaGearData.Activities.Activity{
      name: sequence("activity_name"),
      strava_id: sequence("strava_activity_id", & &1),
      type: "Ride",
      achievement_count: Enum.random(1..50),
      distance: random_float(1, 100),
      average_speed: random_float(1, 10),
      max_speed: random_float(1, 10),
      total_elevation_gain: random_float(1, 2000),
      elapsed_time: Enum.random(1..10_000),
      moving_time: Enum.random(1..10_000),
      start_date_local: "2021-10-19T16:04:09Z",
      timezone: "(GMT-07:00) America/Edmonton",
      athlete: build(:athlete)
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

  def api_token_factory() do
    %StravaGearData.Api.Token{
      access_token: "fake-access-token",
      expires_at: 1_618_987_211,
      other_params: %{
        athlete: %StravaGearData.Api.Athlete{
          bikes: [],
          firstname: "Samuel",
          id: 7_660_837,
          lastname: "Willis",
          profile_medium:
            "https://dgalywyr863hv.cloudfront.net/pictures/athletes/7660837/5433166/1/medium.jpg",
          shoes: [],
          username: "samuelwillis"
        }
      },
      refresh_token: "fake-refresh-token",
      token_type: "Bearer"
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

  def api_activity_factory() do
    %StravaGearData.Api.Activity{
      id: sequence("activity_id", & &1),
      name: "Activity Name",
      type: "Ride",
      achievement_count: 10,
      distance: 10.0,
      average_speed: 1.0,
      max_speed: 1.0,
      total_elevation_gain: 10.0,
      elapsed_time: 420,
      moving_time: 420,
      start_date_local: "2021-10-19T16:04:09Z",
      timezone: "(GMT-07:00) America/Edmonton",
      gear_id: sequence("gear_id")
    }
  end

  defp random_float(low \\ 0, high \\ 100), do: low + (high - low) * :rand.uniform()
end
