defmodule StravaGearData.DataCollectionTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.DataCollection

  describe "build_gear_attrs/2" do
    test "returns empty array for no gear" do
      athlete = insert(:athlete)
      api_athlete = build(:api_athlete)

      assert [] == DataCollection.build_gear_attrs(athlete, api_athlete)
    end

    test "returns array of gear attrs for bike" do
      athlete = :athlete |> insert() |> Repo.preload(:gear)

      api_athlete = build(:api_athlete) |> with_bikes()

      assert [_bike_attrs] = DataCollection.build_gear_attrs(athlete, api_athlete)
    end

    test "returns array of gear attrs for shoes" do
      athlete = :athlete |> insert() |> Repo.preload(:gear)

      api_athlete = build(:api_athlete) |> with_shoes()

      assert [_shoeattrs] = DataCollection.build_gear_attrs(athlete, api_athlete)
    end

    test "returns array of gear attrs for shoes and bikes" do
      athlete = :athlete |> insert() |> Repo.preload(:gear)
      api_athlete = :api_athlete |> build() |> with_bikes(2) |> with_shoes(2)

      assert [_, _, _, _] = DataCollection.build_gear_attrs(athlete, api_athlete)
    end
  end

  describe "cast_gear/1" do
    test "casts gear correctly" do
      api_gear = build(:api_gear)

      assert %{
               strava_id: api_gear.id,
               name: api_gear.name,
               primary: api_gear.primary
             } == DataCollection.cast_gear(api_gear)
    end
  end
end
