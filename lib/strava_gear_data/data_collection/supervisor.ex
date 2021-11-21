defmodule StravaGearData.DataCollection.Supervisor do
  @moduledoc false

  alias StravaGearData.DataCollection.Worker
  alias StravaGearData.Athletes.Athlete

  @doc false
  @callback gather_athlete_data(Athlete.t()) :: term()
  def gather_athlete_data(athlete) do
    Task.Supervisor.start_child(
      __MODULE__,
      StravaGearData.DataCollection.Worker,
      :gather_athlete_data,
      [athlete],
      restart: :transient
    )
  end
end

defmodule StravaGearData.DataCollection.StubSupervisor do
  @moduledoc false

  @behaviour StravaGearData.DataCollection.Supervisor

  alias StravaGearData.DataCollection.Worker

  @doc false
  def gather_athlete_data(athlete) do
    Worker.gather_athlete_data(athlete)
  end
end
