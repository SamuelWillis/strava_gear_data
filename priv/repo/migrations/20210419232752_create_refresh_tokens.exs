defmodule StravaGearData.Repo.Migrations.CreateRefreshTokens do
  use Ecto.Migration

  def change do
    create table(:refresh_tokens) do
      add(:token, :string)

      add(:athlete_id, references(:athletes, type: :uuid, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(unique_index(:refresh_tokens, [:athlete_id]))
  end
end
