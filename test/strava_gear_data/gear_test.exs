defmodule StravaGearData.GearTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Athletes.Athlete
  alias StravaGearData.Gear

  describe "get_athlete_gear!/2" do
    setup do
      {:ok, athlete: insert(:athlete)}
    end

    test "returns piece of gear for athlete", %{athlete: athlete} do
      gear = insert(:gear, athlete: athlete)

      assert %Gear.Gear{} = fetched_gear = Gear.get_athlete_gear!(athlete, gear.id)

      assert fetched_gear.id == gear.id
      assert fetched_gear.athlete_id == athlete.id
    end

    test "throws error if no gear found", %{athlete: athlete} do
      assert_raise Ecto.NoResultsError, fn ->
        Gear.get_athlete_gear!(athlete, Ecto.UUID.generate())
      end
    end

    test "throws error if gear does not belong to athlete", %{athlete: athlete} do
      assert_raise Ecto.NoResultsError, fn ->
        gear = insert(:gear)
        Gear.get_athlete_gear!(athlete, gear.id)
      end
    end
  end

  describe "get_for!/1" do
    test "returns single gear" do
      athlete = :athlete |> build() |> with_gear() |> insert()

      assert [gear] = Gear.get_for!(athlete)

      assert is_struct(gear, Gear.Gear)
      assert gear.athlete_id == athlete.id
    end

    test "returns many gear" do
      athlete = :athlete |> build() |> with_gear(5) |> insert()

      athlete_gear = Gear.get_for!(athlete)

      assert Enum.count(athlete_gear) == 5

      Enum.each(athlete_gear, fn gear ->
        assert is_struct(gear, Gear.Gear)

        assert gear.athlete_id == athlete.id
      end)
    end

    test "returns no gear" do
      athlete = :athlete |> build() |> insert()

      assert [] == Gear.get_for!(athlete)
    end

    test "returns gear with preloaded assoc" do
      athlete = :athlete |> build() |> with_gear() |> insert()

      assert [gear] = Gear.get_for!(athlete, preload: :athlete)

      assert %Athlete{} = gear.athlete
    end

    test "returns gear with multiple preloaded assocs" do
      athlete = :athlete |> build() |> with_gear() |> insert()

      assert [gear] = Gear.get_for!(athlete, preload: [:activities, :athlete])

      assert %Athlete{} = gear.athlete
      assert is_list(gear.activities)
    end

    test "returns gear with stats loaded" do
      athlete = :athlete |> build() |> with_gear() |> insert()

      assert [gear] = Gear.get_for!(athlete, preload: :activities)

      assert gear.distance ==
               gear.activities
               |> Enum.map(& &1.distance)
               |> Enum.sum()

      assert gear.elapsed_time ==
               gear.activities
               |> Enum.map(& &1.elapsed_time)
               |> Enum.sum()

      assert gear.total_elevation_gain ==
               gear.activities
               |> Enum.map(& &1.total_elevation_gain)
               |> Enum.sum()

      assert gear.activity_count == Enum.count(gear.activities)
    end
  end

  describe "insert_all/1" do
    test "inserts new gear" do
      athlete = insert(:athlete)

      attrs = [
        %{
          athlete_id: athlete.id,
          strava_id: "gear_id",
          name: "gear_name",
          primary: true,
          inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
          updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        }
      ]

      assert {1, _} = Gear.insert_all(attrs)

      gear_attrs = List.first(attrs)
      %{gear: [updated_gear]} = athlete |> Repo.reload() |> Repo.preload(:gear)

      assert updated_gear.strava_id == gear_attrs.strava_id
      assert updated_gear.name == gear_attrs.name
      assert updated_gear.primary == gear_attrs.primary
    end

    test "updates existing gear" do
      %{gear: [original_gear]} = athlete = :athlete |> build() |> with_gear() |> insert()

      attrs = [
        %{
          athlete_id: athlete.id,
          strava_id: original_gear.strava_id,
          name: "new name",
          primary: true,
          inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
          updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        }
      ]

      assert {1, _} = Gear.insert_all(attrs)

      gear_attrs = List.first(attrs)
      %{gear: [updated_gear]} = athlete |> Repo.reload() |> Repo.preload(:gear)

      assert updated_gear.strava_id == original_gear.strava_id
      assert updated_gear.name == gear_attrs.name
      assert updated_gear.primary == gear_attrs.primary

      assert updated_gear.inserted_at == original_gear.inserted_at
    end
  end
end
