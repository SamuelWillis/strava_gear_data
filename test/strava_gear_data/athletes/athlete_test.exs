defmodule StravaGearData.Athletes.AthleteTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Athletes.Athlete

  describe "changeset/2" do
    test "requires strava id" do
      attrs = %{
        access_token: params_for(:access_token, athlete: nil),
        refresh_token: params_for(:access_token, athlete: nil)
      }

      changeset = Athlete.changeset(%Athlete{}, attrs)

      refute changeset.valid?

      assert "can't be blank" in errors_on(changeset).strava_id
    end
  end
end
