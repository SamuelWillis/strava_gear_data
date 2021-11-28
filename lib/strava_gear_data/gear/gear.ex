defmodule StravaGearData.Gear.Gear do
  @moduledoc """
  A module to represent a piece of gear.

  Can be a bike or shoes.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias StravaGearData.Activities.Activity
  alias StravaGearData.Athletes.Athlete

  @type t :: %__MODULE__{
          name: binary(),
          primary: boolean(),
          strava_id: binary(),
          athlete: Athlete.t()
        }

  @type attrs_t :: %{
          name: binary(),
          primary: boolean(),
          strava_id: binary(),
          athlete_id: binary()
        }

  defmodule Stats do
    @moduledoc false

    use Ecto.Schema

    embedded_schema do
    end
  end

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gear" do
    field :name, :string
    field :primary, :boolean, default: false
    field :strava_id, :string

    field :distance, :float, virtual: true
    field :elapsed_time, :integer, virtual: true
    field :total_elevation_gain, :float, virtual: true
    field :activity_count, :integer, virtual: true

    has_many :activities, Activity
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
  @spec by_athlete_id_query(Ecto.Queryable.t(), Ecto.UUID.t(), any()) ::
          Ecto.Query.t()
  def by_athlete_id_query(query \\ @base_query, athlete_id, opts) do
    preload = Keyword.get(opts, :preload)

    from gear in query,
      left_join: athlete in assoc(gear, :athlete),
      where: gear.athlete_id == ^athlete_id,
      preload: ^preload
  end

  def with_stats_query(query \\ @base_query) do
    from gear in query,
      left_join: activity in assoc(gear, :activities),
      group_by: gear.id,
      select: gear,
      select_merge: %{
        distance: sum(activity.distance),
        elapsed_time: sum(activity.elapsed_time),
        total_elevation_gain: sum(activity.total_elevation_gain),
        activity_count: count(activity)
      }
  end
end
