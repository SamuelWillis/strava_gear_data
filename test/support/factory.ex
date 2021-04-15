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
end
