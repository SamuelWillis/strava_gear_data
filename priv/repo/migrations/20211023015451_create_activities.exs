defmodule StravaGearData.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:strava_id, :integer)
      add(:name, :string)
      add(:type, :string)
      add(:achievement_count, :integer)
      add(:distance, :float)
      add(:average_speed, :float)
      add(:max_speed, :float)
      add(:total_elevation_gain, :float)
      add(:elapsed_time, :integer)
      add(:moving_time, :integer)
      add(:start_date_local, :integer)
      add(:timezone, :string)

      add(:gear_id, references(:gear, type: :uuid, on_delete: :delete_all, type: :binary_id))
      add(:athlete_id, references(:athletes, type: :uuid, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(unique_index(:activities, [:strava_id]))

    create(index(:activities, [:gear_id]))
    create(index(:activities, [:athlete_id]))
  end
end
