defmodule StravaGearData.DataCollection.Core do
  @moduledoc false

  alias StravaGearData.Api

  @doc """
  Builds the attrs needed to insert the gear for an athlete from the API
  """
  def build_gear_attrs(athlete, %{bikes: bikes, shoes: shoes}) do
    []
    |> do_build_gear_attrs(bikes)
    |> do_build_gear_attrs(shoes)
    |> Stream.map(&put_date(&1, :inserted_at))
    |> Stream.map(&put_date(&1, :updated_at))
    |> Stream.map(fn attrs ->
      case Enum.find(athlete.gear, &(&1.strava_id == attrs["strava_id"])) do
        nil -> attrs
        matched_gear -> Map.put(attrs, :id, matched_gear.id)
      end
    end)
    |> Enum.map(&Map.put(&1, :athlete_id, athlete.id))
  end

  defp do_build_gear_attrs(gear_attrs, [gear_data | tail]),
    do: do_build_gear_attrs([cast_gear(gear_data) | gear_attrs], tail)

  defp do_build_gear_attrs(gear_attrs, []), do: gear_attrs

  @spec cast_gear(Api.Athlete.gear_t()) :: map()
  def cast_gear(%{
        id: strava_id,
        name: name,
        primary: primary
      }) do
    %{
      strava_id: strava_id,
      name: name,
      primary: primary
    }
  end

  @doc """
  Builds the attrs needed to insert the activities for an athlete from the API
  """
  def build_activity_attrs(athlete, attrs) do
    []
    |> do_build_activity_attrs(attrs)
    |> Stream.map(&put_date(&1, :inserted_at))
    |> Stream.map(&put_date(&1, :updated_at))
    |> Stream.map(fn activity_attrs ->
      case Enum.find(athlete.activities, &(&1.strava_id == activity_attrs.strava_id)) do
        nil ->
          activity_attrs

        saved_activity ->
          Map.put(activity_attrs, :id, saved_activity.id)
      end
    end)
    |> Stream.map(fn activity_attrs ->
      activity_attrs =
        case Enum.find(athlete.gear, &(&1.strava_id == activity_attrs.strava_gear_id)) do
          nil ->
            activity_attrs

          saved_gear ->
            Map.put(activity_attrs, :gear_id, saved_gear.id)
        end

      Map.delete(activity_attrs, :strava_gear_id)
    end)
    |> Enum.map(&Map.put(&1, :athlete_id, athlete.id))
  end

  defp do_build_activity_attrs(athlete_attrs, [activity_data | tail]),
    do: do_build_activity_attrs([cast_activity(activity_data) | athlete_attrs], tail)

  defp do_build_activity_attrs(athlete_attrs, []), do: athlete_attrs

  @doc false
  def cast_activity(%{
        id: strava_id,
        name: name,
        type: type,
        achievement_count: achievement_count,
        distance: distance,
        average_speed: average_speed,
        max_speed: max_speed,
        total_elevation_gain: total_elevation_gain,
        start_date_local: start_date_local,
        timezone: timezone,
        elapsed_time: elapsed_time,
        moving_time: moving_time,
        gear_id: strava_gear_id
      }) do
    {:ok, start_date_local, _tz} = DateTime.from_iso8601(start_date_local)

    %{
      strava_id: strava_id,
      name: name,
      type: type,
      achievement_count: achievement_count,
      distance: distance,
      average_speed: average_speed,
      max_speed: max_speed,
      total_elevation_gain: total_elevation_gain,
      start_date_local: start_date_local,
      timezone: timezone,
      elapsed_time: elapsed_time,
      moving_time: moving_time,
      strava_gear_id: strava_gear_id
    }
  end

  defp put_date(attrs, key),
    do: Map.put_new(attrs, key, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
end
