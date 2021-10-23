defmodule StravaGearData.Athletes.Athlete do
  @moduledoc """
  Schema for an athlete and their information.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias StravaGearData.Athletes.AccessToken
  alias StravaGearData.Athletes.RefreshToken
  alias StravaGearData.Activities.Activity
  alias StravaGearData.Gear.Gear

  @type t :: %__MODULE__{
          id: binary(),
          strava_id: :integer,
          first_name: String.t() | nil,
          last_name: String.t() | nil,
          username: String.t() | nil,
          profile_picture: String.t() | nil,
          gear: [Gear] | nil,
          access_token: AccessToken | nil,
          refresh_token: RefreshToken | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "athletes" do
    field :strava_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :profile_picture, :string

    has_many :gear, Gear, on_replace: :delete_if_exists
    has_many :activities, Activity

    has_one :access_token, AccessToken, on_replace: :update
    has_one :refresh_token, RefreshToken, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(athlete, attrs) do
    athlete
    |> cast(attrs, [:strava_id, :first_name, :last_name, :username, :profile_picture])
    |> unique_constraint(:strava_id)
    |> validate_required([:strava_id])
    |> cast_assoc(:access_token, required: true)
    |> cast_assoc(:refresh_token, required: true)
  end
end
