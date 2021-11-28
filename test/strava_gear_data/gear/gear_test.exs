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

    test "requires existing athlete in the DB" do
      attrs = %{
        athlete_id: Ecto.UUID.generate(),
        name: "Bike",
        primary: true,
        strava_id: "gear_id"
      }

      assert {:error, changeset} =
               %Gear{}
               |> Gear.changeset(attrs)
               |> Repo.insert()

      refute changeset.valid?, inspect(changeset)

      assert "does not exist" in errors_on(changeset).athlete
    end
  end
end
