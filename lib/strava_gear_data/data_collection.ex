defmodule StravaGearData.DataCollection do
  @moduledoc """
  Handles all the logic related to gathering an Athlete's data from strava and
  persisting it to the DB.
  """

  alias StravaGearData.Athletes.Athlete

  @supervisor Application.compile_env(
                :strava_gear_data,
                :data_collection_supervisor,
                StravaGearData.DataCollection.Supervisor
              )

  @doc """
  Starts the gather athlete data process.

  Broadcasts a :gather_athlete_data_complete event containing the updated
  athlete after the work is complete.
  """
  @spec gather_athlete_data(Athlete.t()) :: {:ok, pid()}
  def gather_athlete_data(athlete) do
    supervisor().gather_athlete_data(athlete)
  end

  @doc """
  Subscribe to the Data Collection PubSub broadcasts
  """
  @spec subscribe(Athlete.t()) :: :ok | {:error, term()}
  def subscribe(athlete),
    do: Phoenix.PubSub.subscribe(StravaGearData.PubSub, topic(athlete))

  @doc """
  Unsubscribe from the Data Collection PubSub broadcasts
  """
  @spec unsubscribe(Athlete.t()) :: :ok | {:error, term()}
  def unsubscribe(athlete),
    do: Phoenix.PubSub.unsubscribe(StravaGearData.PubSub, topic(athlete))

  @doc """
  Broadcast an event on the Data Collection PubSub topic
  """
  @spec broadcast(Athlete.t(), atom() | tuple()) :: :ok | {:error, term()}
  def broadcast(athlete, event),
    do:
      Phoenix.PubSub.broadcast(
        StravaGearData.PubSub,
        topic(athlete),
        event
      )

  defp topic(athlete), do: "data_collection:#{athlete.id}"

  defp supervisor(), do: @supervisor
end
