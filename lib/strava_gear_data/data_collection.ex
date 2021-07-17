defmodule StravaGearData.DataCollection do
  @moduledoc """
  Context to handle gathering data from Strava and persisting it to our
  database
  """
  alias StravaGearData.Api
  alias StravaGearData.Gear
  alias StravaGearData.Repo

  @doc """
  Gather the athlete's gear from Strava and persist it to the DB
  """
  def gather_athlete_gear(athlete) do
    athlete = Repo.preload(athlete, :gear)
    api_athlete = Api.get_athlete(athlete)

    gear_attrs = build_gear_attrs(athlete, api_athlete)
    {_, nil} = Gear.insert_all(gear_attrs)
  end

  @doc false
  def build_gear_attrs(athlete, %{bikes: bikes, shoes: shoes}) do
    []
    |> do_build_gear_attrs(bikes)
    |> do_build_gear_attrs(shoes)
    |> Stream.map(
      &Map.put_new(&1, :inserted_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
    )
    |> Stream.map(
      &Map.put_new(&1, :updated_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
    )
    |> Stream.map(fn attrs ->
      case Enum.find(athlete.gear, &(&1.strava_id == attrs["strava_id"])) do
        nil -> attrs
        matched_gear -> Map.put(attrs, :id, matched_gear.id)
      end
    end)
    |> Enum.map(&Map.put(&1, :athlete_id, athlete.id))
  end

  @spec do_build_gear_attrs(list(), [Api.Athlete.gear_t()]) :: [map()]
  defp do_build_gear_attrs(gear_attrs, [gear_data | tail]),
    do: do_build_gear_attrs([cast_gear(gear_data) | gear_attrs], tail)

  defp do_build_gear_attrs(gear_attrs, []), do: gear_attrs

  @spec cast_gear(Api.Athlete.gear_t()) :: map()
  def cast_gear(%{
        id: strava_id,
        name: name,
        primary: primary
      }),
      do: %{
        strava_id: strava_id,
        name: name,
        primary: primary
      }
end
