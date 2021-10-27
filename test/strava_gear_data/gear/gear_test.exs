defmodule StravaGearData.Gear.GearTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Athletes.Athlete
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

  describe "by_athlete_id_query/2" do
    test "returns proper query using base_query" do
      %{id: athlete_id} = build(:athlete) |> with_gear() |> insert()

      expected_query =
        from gear in Gear,
          join: athlete in Athlete,
          as: :athlete,
          on: gear.athlete_id == ^athlete_id

      assert inspect(expected_query) == inspect(Gear.by_athlete_id_query(athlete_id))
    end
  end
end
