defmodule StravaGearData.Athletes.Athlete do
  @moduledoc """
  Schema for an athlete and their information.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias StravaGearData.Athletes.AccessToken

  @type t :: %__MODULE__{
          id: binary(),
          strava_id: :integer,
          first_name: String.t() | nil,
          last_name: String.t() | nil,
          username: String.t() | nil,
          profile_picture: String.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "athletes" do
    field :strava_id, :integer
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :profile_picture, :string

    has_one :access_token, AccessToken, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(athlete, attrs) do
    athlete
    |> cast(attrs, [:strava_id, :first_name, :last_name, :username, :profile_picture])
    |> unique_constraint(:strava_id)
    |> validate_required([:strava_id])
  end
end
