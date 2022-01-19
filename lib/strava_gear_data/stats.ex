defmodule StravaGearData.Stats do
  @moduledoc """
  Determines different statistics for given pieces of gear
  """
  import Ecto.Query

  alias StravaGearData.Activities.Activity
  alias StravaGearData.Repo

  def weekly_stats(gear) do
    query =
      from a in Activity,
        where: a.gear_id == ^gear.id,
        select: %{
          week: fragment("date_trunc('week', ?)", field(a, :start_date_local)),
          distance: sum(a.distance),
          elevation: sum(a.total_elevation_gain)
        },
        group_by: [fragment("date_trunc('week', ?)", field(a, :start_date_local))],
        order_by: [fragment("date_trunc('week', ?)", field(a, :start_date_local))]

    Repo.all(query)
  end
end
