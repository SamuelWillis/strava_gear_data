defmodule StravaGearDataWeb.GearLive do
  @moduledoc false
  use StravaGearDataWeb, :live_view

  alias StravaGearData.Athletes
  alias StravaGearData.Gear

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
end
