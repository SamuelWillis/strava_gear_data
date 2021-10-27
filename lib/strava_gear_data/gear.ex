defmodule StravaGearData.Gear do
  @moduledoc """
  The Gear context
  """

  alias StravaGearData.Athletes.Athlete
  alias StravaGearData.Gear.Gear, as: GearEntity
  alias StravaGearData.Repo

  @doc """
  Get the gear for an athlete
  """

  @spec get_for!(Athlete.t()) :: [GearEntity.t()]
  def get_for!(%Athlete{id: athlete_id}) do
    GearEntity
    |> GearEntity.by_athlete_id_query(athlete_id)
    |> Repo.all()
  end

  @doc """
  Insert all the gear given by the provided gear attrs.

  This does a batch insert of all the provided gear and expects the attrs to
  include the associated athlete ID and timestamps.

  On conflict of the strava_id all fields are replaced except for the:
    - id
    - strava_id
    - inserted_at
  """
  @spec insert_all([GearEntity.attrs_t()]) :: {integer(), nil}
  def insert_all(gear_attrs) do
    Repo.insert_all(GearEntity, gear_attrs,
      conflict_target: :strava_id,
      on_conflict: {:replace_all_except, [:id, :strava_id, :inserted_at]}
    )
  end
end
