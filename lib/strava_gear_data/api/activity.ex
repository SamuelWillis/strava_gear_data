defmodule StravaGearData.Api.Activity do
  @moduledoc """
  Representation of athlete returned by the Strava API
  """

  defstruct [
    :id,
    :name,
    :type,
    :achievement_count,
    :distance,
    :average_speed,
    :max_speed,
    :total_elevation_gain,
    :start_date_local,
    :timezone,
    :elapsed_time,
    :moving_time,
    :gear_id
  ]

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          type: String.t(),
          achievement_count: integer(),
          distance: float(),
          average_speed: float(),
          max_speed: float(),
          total_elevation_gain: float(),
          elapsed_time: integer(),
          moving_time: integer(),
          start_date_local: integer(),
          timezone: String.t(),
          gear_id: String.t()
        }

  def from!(%{
        "id" => id,
        "name" => name,
        "type" => type,
        "achievement_count" => achievement_count,
        "distance" => distance,
        "average_speed" => average_speed,
        "max_speed" => max_speed,
        "total_elevation_gain" => total_elevation_gain,
        "start_date_local" => start_date_local,
        "timezone" => timezone,
        "elapsed_time" => elapsed_time,
        "moving_time" => moving_time,
        "gear_id" => gear_id
      }) do
    struct!(__MODULE__, %{
      id: id,
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
      gear_id: gear_id
    })
  end
end
