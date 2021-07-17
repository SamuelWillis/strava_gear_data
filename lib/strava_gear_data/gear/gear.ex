defmodule StravaGearData.Gear.Gear do
  @moduledoc """
  A module to represent a piece of gear.

  Can be a bike or shoes.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias StravaGearData.Athletes.Athlete

  @type t :: %__MODULE__{
          name: binary(),
          primary: boolean(),
          strava_id: binary(),
          athlete: Athlete.t()
        }

  @type gear_attrs_t :: %{
          name: binary(),
          primary: boolean(),
          strava_id: binary(),
          athlete_id: binary()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "gear" do
    field :name, :string
    field :primary, :boolean, default: false
    field :strava_id, :string

    belongs_to :athlete, Athlete, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(gear, attrs) do
    gear
    |> cast(attrs, [:athlete_id, :strava_id, :name, :primary])
    |> assoc_constraint(:athlete)
    |> unique_constraint(:strava_id)
    |> validate_required([:strava_id, :name])
  end
end
