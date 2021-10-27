defmodule StravaGearData.ActivitiesTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Activities

  describe "insert_all/1" do
    test "inserts new activity" do
      %{gear: [original_gear]} = athlete = :athlete |> build() |> with_gear() |> insert()

      {:ok, start_date_local, _} = DateTime.from_iso8601("2021-10-19T16:04:09Z")

      attrs = [
        %{
          name: "Test Ride",
          athlete_id: athlete.id,
          gear_id: original_gear.id,
          strava_id: 42_000,
          achievement_count: 10,
          distance: 100.0,
          average_speed: 1.0,
          max_speed: 1.5,
          total_elevation_gain: 420.0,
          elapsed_time: 7477,
          moving_time: 5881,
          start_date_local: start_date_local,
          timezone: "(GMT-07:00) America/Edmonton",
          inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
          updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        }
      ]

      assert {1, _} = Activities.insert_all(attrs)

      updated_athlete = athlete |> Repo.reload() |> Repo.preload([:activities, :gear])

      assert [activity] = updated_athlete.activities

      assert activity.gear_id == original_gear.id
    end

    test "updates existing activity" do
      athlete = :athlete |> build() |> with_activities() |> insert()
      activity = hd(athlete.activities)

      {:ok, start_date_local, _} = DateTime.from_iso8601("2021-10-19T16:04:09Z")

      attrs = [
        %{
          id: activity.id,
          name: "Test Ride",
          athlete_id: athlete.id,
          strava_id: activity.strava_id,
          achievement_count: 10,
          distance: 100.0,
          average_speed: 1.0,
          max_speed: 1.5,
          total_elevation_gain: 420.0,
          elapsed_time: 7477,
          moving_time: 5881,
          start_date_local: start_date_local,
          timezone: "(GMT-07:00) America/Edmonton",
          inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
          updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        }
      ]

      assert {1, _} = Activities.insert_all(attrs)

      updated_athlete = athlete |> Repo.reload() |> Repo.preload([:activities, :gear])

      assert [updated_activity] = updated_athlete.activities

      assert updated_activity.id == activity.id
    end
  end
end
