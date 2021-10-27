defmodule StravaGearData.DataCollection.CoreTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.DataCollection.Core

  describe "build_gear_attrs/2" do
    test "returns empty array for no gear" do
      athlete = insert(:athlete)
      api_athlete = build(:api_athlete)

      assert [] == Core.build_gear_attrs(athlete, api_athlete)
    end

    test "returns array of gear attrs for bike" do
      athlete = :athlete |> insert() |> Repo.preload(:gear)

      api_athlete = build(:api_athlete) |> with_bikes()

      assert [bike_attrs] = Core.build_gear_attrs(athlete, api_athlete)

      assert bike_attrs.athlete_id == athlete.id
    end

    test "returns array of gear attrs for shoes" do
      athlete = :athlete |> insert() |> Repo.preload(:gear)

      api_athlete = build(:api_athlete) |> with_shoes()

      assert [shoe_attrs] = Core.build_gear_attrs(athlete, api_athlete)

      assert shoe_attrs.athlete_id == athlete.id
    end

    test "returns array of gear attrs for shoes and bikes" do
      athlete = :athlete |> insert() |> Repo.preload(:gear)
      api_athlete = :api_athlete |> build() |> with_bikes(2) |> with_shoes(2)

      assert gear = Core.build_gear_attrs(athlete, api_athlete)

      assert length(gear) == 4

      Enum.each(gear, fn g ->
        assert g.athlete_id == athlete.id
      end)
    end
  end

  describe "build_athlete_attrs/2" do
    test "returns empty array for no activities" do
      athlete = insert(:athlete)

      assert [] == Core.build_activity_attrs(athlete, [])
    end

    test "returns activity attrs for new activity" do
      athlete = :athlete |> insert() |> Repo.preload([:activities, :gear])
      api_activitiy = build_list(1, :api_activity)

      assert [activity_attrs] = Core.build_activity_attrs(athlete, api_activitiy)

      assert activity_attrs.athlete_id == athlete.id
    end

    test "returns array of activity attrs" do
      athlete = :athlete |> insert() |> Repo.preload([:activities, :gear])
      api_activities = build_list(4, :api_activity)

      assert activities = Core.build_activity_attrs(athlete, api_activities)

      assert length(activities) == 4

      Enum.each(activities, fn activity ->
        assert activity.athlete_id == athlete.id
      end)
    end
  end

  describe "cast_gear/1" do
    test "casts gear correctly" do
      api_gear = build(:api_gear)

      assert %{
               strava_id: api_gear.id,
               name: api_gear.name,
               primary: api_gear.primary
             } == Core.cast_gear(api_gear)
    end
  end

  describe "cast_activity/1" do
    test "casts activity correctly" do
      api_activity = build(:api_activity)

      {:ok, start_date_local, _tz} = DateTime.from_iso8601(api_activity.start_date_local)

      assert %{
               strava_id: api_activity.id,
               name: api_activity.name,
               type: api_activity.type,
               achievement_count: api_activity.achievement_count,
               distance: api_activity.distance,
               average_speed: api_activity.average_speed,
               max_speed: api_activity.max_speed,
               total_elevation_gain: api_activity.total_elevation_gain,
               start_date_local: start_date_local,
               timezone: api_activity.timezone,
               elapsed_time: api_activity.elapsed_time,
               moving_time: api_activity.moving_time,
               strava_gear_id: api_activity.gear_id
             } == Core.cast_activity(api_activity)
    end
  end
end
