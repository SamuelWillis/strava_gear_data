defmodule StravaGearData.Athletes.RefreshToken do
  @moduledoc """
  Refresh token for the Strava API
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          token: String.t(),
          athlete: StravaGearData.Athletes.Athlete.t()
        }

  @foreign_key_type :binary_id
  schema "refresh_tokens" do
    field :token, :string
    belongs_to :athlete, StravaGearData.Athletes.Athlete

    timestamps()
  end

  @doc false
  def changeset(refresh_token, attrs) do
    refresh_token
    |> cast(attrs, [:athlete_id, :token])
    |> validate_required([:token])
    |> assoc_constraint(:athlete)
    |> unique_constraint(:athlete_id)
  end
end
