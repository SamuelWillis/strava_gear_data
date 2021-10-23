defmodule StravaGearData.Activities.ActivityTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Activities.Activity

  describe "changeset/2" do
    test "requires all fields" do
      attrs = %{}

      changeset = Activity.changeset(%Activity{}, attrs)

      refute changeset.valid?

      assert "can't be blank" in errors_on(changeset).strava_id
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).type
      assert "can't be blank" in errors_on(changeset).achievement_count
      assert "can't be blank" in errors_on(changeset).distance
      assert "can't be blank" in errors_on(changeset).average_speed
      assert "can't be blank" in errors_on(changeset).max_speed
      assert "can't be blank" in errors_on(changeset).total_elevation_gain
      assert "can't be blank" in errors_on(changeset).elapsed_time
      assert "can't be blank" in errors_on(changeset).moving_time
      assert "can't be blank" in errors_on(changeset).start_date_local
      assert "can't be blank" in errors_on(changeset).timezone
    end
  end
end
