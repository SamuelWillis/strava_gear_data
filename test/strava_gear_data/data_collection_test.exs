defmodule StravaGearData.DataCollectionTest do
  use StravaGearData.DataCase, async: true

  import Mox

  alias StravaGearData.Activities.Activity
  alias StravaGearData.DataCollection
  alias StravaGearData.Gear.Gear

  setup :verify_on_exit!

  setup do
    {:ok, athlete: insert(:athlete)}
  end

  describe "gather_athlete_data/1" do
    test "gets data from Strava and persists it to database", %{athlete: athlete} do
      {api_athlete, api_activities} = build_api_data(athlete)

      StravaGearData.Api.MockClient
      |> expect(:get_athlete, fn _athlete ->
        api_athlete
      end)
      |> expect(:get_activities_for, fn _athlete, _opts ->
        api_activities
      end)
      |> expect(:get_activities_for, fn _athlete, _opts ->
        []
      end)

      assert {:ok, athlete} = DataCollection.gather_athlete_data(athlete)

      assert [%Gear{}, %Gear{}] = athlete.gear

      assert Enum.count(athlete.activities) == 15

      Enum.each(athlete.activities, &assert(%Activity{} = &1))
    end

    test "broadcasts event when complete", %{athlete: athlete} do
      DataCollection.subscribe(athlete)
      {api_athlete, api_activities} = build_api_data(athlete)

      StravaGearData.Api.MockClient
      |> expect(:get_athlete, fn _athlete ->
        api_athlete
      end)
      |> expect(:get_activities_for, fn _athlete, _opts ->
        api_activities
      end)
      |> expect(:get_activities_for, fn _athlete, _opts ->
        []
      end)

      assert {:ok, athlete} = DataCollection.gather_athlete_data(athlete)

      assert_received {:gather_athlete_data_complete, ^athlete}
    end
  end

  describe "broadcast/2" do
    test "broadcasts to the data collection channel" do
      athlete = insert(:athlete)

      assert :ok = DataCollection.subscribe(athlete)

      assert :ok = DataCollection.broadcast(athlete, :test_broadcast)

      assert_received :test_broadcast
    end
  end

  defp build_api_data(athlete) do
    api_shoes = build(:api_gear)
    api_bike = build(:api_gear)

    api_athlete =
      build(:api_athlete, id: athlete.strava_id, shoes: [api_shoes], bikes: [api_bike])

    api_activities =
      build_list(5, :api_activity, gear_id: api_shoes.id) ++
        build_list(5, :api_activity, gear_id: api_bike.id) ++ build_list(5, :api_activity)

    {api_athlete, api_activities}
  end
end
