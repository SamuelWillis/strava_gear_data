defmodule StravaGearData.Gear.Gear do
  @moduledoc """
  A module to represent a piece of gear.

  Can be a bike or shoes.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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
  @foreign_key_type :binary_id
  schema "gear" do
    field :name, :string
    field :primary, :boolean, default: false
    field :strava_id, :string

    belongs_to :athlete, Athlete

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

  # --- Gear Queries --- #
  @base_query __MODULE__

  @doc """
  Retrieve Gear by athlete ID
  """
  @spec by_athlete_id_query(Ecto.Queryable.t(), binary()) :: Ecto.Query.t()
  def by_athlete_id_query(query \\ @base_query, athlete_id) do
    from gear in query, join: athlete in Athlete, as: :athlete, on: gear.athlete_id == ^athlete_id
  end
end
