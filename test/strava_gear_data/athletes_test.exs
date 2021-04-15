defmodule StravaGearData.AthletesTest do
  use StravaGearData.DataCase

  alias StravaGearData.Athletes
  alias StravaGearData.Athletes.Athlete

  @valid_attrs %{
    strava_id: 123,
    first_name: "Test",
    last_name: "Athlete",
    username: "testathlete",
    profile_picture: "https://profile.picture/of/athlete"
  }

  @update_attrs %{
    first_name: "New",
    last_name: "Name",
    username: "newtestathlete",
    profile_picture: "https://new.profile.picture/of/athlete"
  }

  describe "get_athlete/1" do
    test "get_athlete!/1 returns the athlete with given id" do
      athlete = insert(:athlete)
      assert Athletes.get_athlete!(athlete.id) == athlete
    end
  end

  describe "create_athlete/1" do
    test "valid data creates a athlete" do
      assert {:ok, %Athlete{} = athlete} = Athletes.create_athlete(@valid_attrs)

      assert athlete.strava_id == @valid_attrs.strava_id
    end

    test "duplicate strava id returns error changeset" do
      athlete = insert(:athlete)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Athletes.create_athlete(%{strava_id: athlete.strava_id})

      refute changeset.valid?

      assert "has already been taken" in errors_on(changeset).strava_id
    end
  end

  describe "update_athlete/2" do
    test "valid data updates the athlete" do
      athlete = insert(:athlete)
      assert {:ok, %Athlete{}} = Athletes.update_athlete(athlete, @update_attrs)
    end

    test "returns error changeset if strava id updated to existing strava id" do
      athlete = insert(:athlete)
      %{strava_id: taken_strava_id} = insert(:athlete)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Athletes.update_athlete(athlete, %{strava_id: taken_strava_id})

      refute changeset.valid?

      assert "has already been taken" in errors_on(changeset).strava_id

      assert athlete == Athletes.get_athlete!(athlete.id)
    end
  end

  describe "delete_athlete/1" do
    test "deletes the athlete" do
      athlete = insert(:athlete)
      assert {:ok, %Athlete{}} = Athletes.delete_athlete(athlete)
      assert_raise Ecto.NoResultsError, fn -> Athletes.get_athlete!(athlete.id) end
    end
  end

  describe "change_athlete/1" do
    test "returns a athlete changeset" do
      athlete = insert(:athlete)
      assert %Ecto.Changeset{} = Athletes.change_athlete(athlete)
    end
  end
end
