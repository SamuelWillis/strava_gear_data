defmodule StravaGearData.Activities.Activity do
  @moduledoc """
  A module to represent an activity.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias StravaGearData.Athletes.Athlete
  alias StravaGearData.Gear.Gear

  @type t :: %__MODULE__{
          strava_id: integer(),
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

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :achievement_count, :integer
    field :average_speed, :float
    field :distance, :float
    field :elapsed_time, :integer
    field :max_speed, :float
    field :moving_time, :integer
    field :name, :string
    field :start_date_local, :integer
    field :strava_id, :integer
    field :timezone, :string
    field :total_elevation_gain, :float
    field :type, :string

    belongs_to :gear, Gear
    belongs_to :athlete, Athlete

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [
      :strava_id,
      :name,
      :type,
      :achievement_count,
      :distance,
      :average_speed,
      :max_speed,
      :total_elevation_gain,
      :elapsed_time,
      :moving_time,
      :start_date_local,
      :timezone
    ])
    |> validate_required([
      :strava_id,
      :name,
      :type,
      :achievement_count,
      :distance,
      :average_speed,
      :max_speed,
      :total_elevation_gain,
      :elapsed_time,
      :moving_time,
      :start_date_local,
      :timezone
    ])
    |> assoc_constraint(:athlete)
    |> assoc_constraint(:gear)
    |> unique_constraint(:strava_id)
  end
end
