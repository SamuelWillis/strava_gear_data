defmodule StravaGearDataWeb.GearLive do
  @moduledoc false
  use StravaGearDataWeb, :live_view

  alias StravaGearData.Athletes
  alias StravaGearData.DataCollection
  alias StravaGearData.Gear

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    athlete = socket.assigns.athlete

    gear = Gear.get_for!(athlete, preload: :activities)

    socket =
      socket
      |> assign(:athlete, athlete)
      |> assign(:gear, gear)
      |> apply_action(socket.assigns.live_action)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket), do: {:noreply, socket}

  @impl Phoenix.LiveView
  def handle_event("delete-athlete-data", _params, %{assigns: assigns} = socket) do
    socket =
      case Athletes.delete_athlete(assigns.athlete) do
        {:ok, _deleted_athlete} ->
          push_redirect(socket, to: Routes.auth_path(socket, :delete))

        {:error, _changeset} ->
          put_flash(socket, :error, gettext("Error deleting athlete"))
      end

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:gather_athlete_data}, socket) do
    :ok = DataCollection.gather_athlete_data(socket.assigns.athlete)

    athlete = socket.assigns.athlete

    gear = Gear.get_for!(athlete, preload: :activities)

    socket = socket |> assign(:gear, gear) |> push_patch(to: Routes.gear_path(socket, :index))

    {:noreply, socket}
  end

  def apply_action(socket, :gather) do
    # This causes problems with testing as a message is sent to itself and then
    # it starts gathering data from an external API.
    #
    # It also is calling a blocking process in the message handler that takes a
    # long time to run.
    if connected?(socket) do
      send(self(), {:gather_athlete_data})
    end

    socket
  end

  def apply_action(socket, _action), do: socket
end
