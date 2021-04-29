defmodule StravaGearData.Gear.GearTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Gear.Gear

  describe "changeset/2" do
    test "requires name, primary, and strava id" do
      attrs = %{}

      changeset = Gear.changeset(%Gear{}, attrs)

      refute changeset.valid?

      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).strava_id
    end
  end
end
