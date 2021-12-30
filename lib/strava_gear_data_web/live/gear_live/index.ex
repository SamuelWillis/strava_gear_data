defmodule StravaGearDataWeb.GearLive.Index do
  @moduledoc false
  use StravaGearDataWeb, :live_view

  alias StravaGearData.Athletes
  alias StravaGearData.DataCollection
  alias StravaGearData.Gear
  alias StravaGearDataWeb.GearLive

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    athlete = socket.assigns.athlete

    DataCollection.subscribe(athlete)

    gear = Gear.get_for!(athlete, preload: :activities)

    socket =
      socket
      |> assign(:athlete, athlete)
      |> assign(:gear, gear)

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

  def handle_event("gather-athlete-data", _params, %{assigns: assigns} = socket) do
    DataCollection.gather_athlete_data(assigns.athlete)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:gather_athlete_data_complete, _athlete}, socket) do
    athlete = socket.assigns.athlete

    gear = Gear.get_for!(athlete, preload: :activities)

    {:noreply, assign(socket, :gear, gear)}
  end
end
