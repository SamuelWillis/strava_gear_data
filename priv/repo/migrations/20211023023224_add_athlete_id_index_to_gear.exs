defmodule StravaGearData.Repo.Migrations.AddAthleteIdIndexToGear do
  use Ecto.Migration

  def change do
    create(index(:gear, [:athlete_id]))
  end
end
