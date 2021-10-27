defmodule StravaGearData.DataCollection do
  @moduledoc """
  Gathers data from Strava and stores it in the database
  """

  alias StravaGearData.Activities
  alias StravaGearData.Api
  alias StravaGearData.DataCollection.Core
  alias StravaGearData.Gear
  alias StravaGearData.Repo

  @doc """
  Gather the athlete's gear from Strava and persist it to the DB
  """
  def gather_athlete_gear(athlete) do
    athlete = Repo.preload(athlete, :gear)
    api_athlete = Api.get_athlete(athlete)

    gear_attrs = Core.build_gear_attrs(athlete, api_athlete)
    {_, nil} = Gear.insert_all(gear_attrs)
  end

  def gather_athlete_activities(athlete) do
    athlete = Repo.preload(athlete, [:activities, :gear])

    gather_athlete_activity_page(athlete)
  end

  defp gather_athlete_activity_page(athlete, page \\ 1) do
    task = Task.async(fn -> Api.get_activities_for(athlete, page: page) end)

    case Task.await(task, 6000) do
      [_ | _] = api_activities ->
        activity_attrs = Core.build_activity_attrs(athlete, api_activities)

        Activities.insert_all(activity_attrs)

        gather_athlete_activity_page(athlete, page + 1)

      [] ->
        page
    end
  end
end
