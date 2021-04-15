defmodule StravaGearData.Athletes.AthleteTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Athletes.Athlete

  describe "changeset/2" do
    test "requires strava id" do
      attrs = %{}

      changeset = Athlete.changeset(%Athlete{}, attrs)

      refute changeset.valid?

      assert "can't be blank" in errors_on(changeset).strava_id
    end

    test "ensures no duplicated strava ids" do
      athlete = insert(:athlete)

      attrs = %{
        strava_id: athlete.strava_id
      }

      assert {:error, changeset} = %Athlete{} |> Athlete.changeset(attrs) |> Repo.insert()

      refute changeset.valid?

      assert "has already been taken" in errors_on(changeset).strava_id
    end
  end
end
