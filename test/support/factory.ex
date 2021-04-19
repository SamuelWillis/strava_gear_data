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

  def with_auth_tokens(athlete) do
    %{
      athlete
      | access_token: build(:access_token, athlete: nil),
        refresh_token: build(:refresh_token, athlete: nil)
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
end
