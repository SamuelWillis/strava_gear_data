defmodule StravaGearData.DataCollection.Worker do
  @moduledoc false

  alias StravaGearData.Activities
  alias StravaGearData.Api
  alias StravaGearData.Athletes.Athlete
  alias StravaGearData.DataCollection
  alias StravaGearData.DataCollection.Core
  alias StravaGearData.Gear
  alias StravaGearData.Repo

  @doc """
  Gather all of the athletes data.

  Does 2 steps:
    1. Get the athletes gear
    2. Get the athlete activities and attachthem to gear and athlete

  Broadcasts to data collection topic when gather is complete.

  Returns the athlete with gear and activities preloaded.
  """
  @spec gather_athlete_data(Athlete.t()) :: {:ok, Athlete.t()}
  def gather_athlete_data(athlete) do
    gather_athlete_gear(athlete)

    gather_athlete_activities(athlete)

    athlete = reload(athlete)

    DataCollection.broadcast(athlete, {:gather_athlete_data_complete, athlete})

    {:ok, athlete}
  end

  @doc """
  Gathers the athlete's gear from Strava.

  To do this, the currently authenticated athlete is requested and the returned
  shoes and bikes are converted into Gear in the DB.
  """
  @spec gather_athlete_gear(Athlete.t()) :: {integer(), nil}
  def gather_athlete_gear(athlete) do
    # Reloading the athlete is needed so we have the most up to date assocs
    # for the athlete.
    athlete = reload(athlete)

    task = Task.async(fn -> Api.get_athlete(athlete) end)

    api_athlete = Task.await(task)

    gear_attrs = Core.build_gear_attrs(athlete, api_athlete)

    {_, nil} = Gear.insert_all(gear_attrs)
  end

  @doc """
  Gather the provided athlete's activities from Strava.

  Strava's API does not provide a way for us to know the number of activities
  an athlete has before we start making requests and it limits the max number
  of returned activities to 50 at a time.

  So this function makes repeated calls for a page of 50 activities, transforms
  them, and saves them to the DB until an empty list is returned from the API.

  This function might get expensive.
  """
  @spec gather_athlete_activities(Athlete.t()) :: integer()
  def gather_athlete_activities(athlete) do
    # Reloading the athlete is needed so we have the most up to date assocs
    # for the athlete.
    athlete = reload(athlete)

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

  defp reload(athlete),
    do:
      athlete
      |> Repo.reload()
      |> Repo.preload([:activities, :gear])
end
