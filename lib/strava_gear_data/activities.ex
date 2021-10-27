defmodule StravaGearData.Activities do
  @moduledoc """
  The Activities context
  """

  alias StravaGearData.Activities.Activity
  alias StravaGearData.Repo

  @spec insert_all([Activity.attrs_t()]) :: {integer, nil}
  def insert_all(activities_attrs) do
    Repo.insert_all(Activity, activities_attrs,
      conflict_target: :strava_id,
      on_conflict: {:replace_all_except, [:id, :strava_id, :inserted_at]}
    )
  end
end
