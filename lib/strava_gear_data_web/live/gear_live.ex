defmodule StravaGearDataWeb.GearLive do
  @moduledoc false
  use StravaGearDataWeb, :live_view

  alias StravaGearData.Athletes
  alias StravaGearData.Gear

  on_mount(StravaGearDataWeb.Live.Hooks.CheckPasswordProtection)

  @impl Phoenix.LiveView
  def mount(_params, %{"token" => token}, socket) do
    {:ok, athlete_id} =
      Phoenix.Token.verify(StravaGearDataWeb.Endpoint, "athlete auth", token, max_age: :infinity)

    athlete = Athletes.get_athlete!(athlete_id)

    gear = Gear.get_for!(athlete)

    socket =
      socket
      |> assign(:athlete, athlete)
      |> assign(:gear, gear)

    {:ok, socket}
  end

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
end
