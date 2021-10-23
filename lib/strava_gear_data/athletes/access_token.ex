defmodule StravaGearData.Athletes.AccessToken do
  @moduledoc """
  AccessToken for Strava API.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          token: String.t(),
          token_type: String.t(),
          expires_at: DateTime.t(),
          athlete: StravaGearData.Athletes.Athlete.t()
        }

  @foreign_key_type :binary_id
  schema "access_tokens" do
    field :expires_at, :utc_datetime
    field :token, :string
    field :token_type, :string
    belongs_to :athlete, StravaGearData.Athletes.Athlete

    timestamps()
  end

  @doc false
  def changeset(access_token, attrs) do
    access_token
    |> cast(attrs, [:athlete_id, :token, :expires_at, :token_type])
    |> validate_required([:token, :expires_at, :token_type])
    |> unique_constraint(:athlete_id)
    |> assoc_constraint(:athlete)
  end
end
