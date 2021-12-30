defmodule StravaGearDataWeb.GearLive.Show do
  @moduledoc false
  use StravaGearDataWeb, :live_view

  alias StravaGearData.Gear
  alias StravaGearDataWeb.GearLive

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    %{athlete: athlete} = socket.assigns

    gear = Gear.get_athlete_gear!(athlete, id)

    {:ok, assign(socket, :gear, gear)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section>
      <header>
        <h1><%= @gear.name %></h1>
      </header>
      <dl class="w-1/2 grid grid-cols-2">
        <dt class="font-semibold"><%= gettext "Activity Count" %></dt>
        <dd>
          <GearLive.stat stat={@gear.activity_count} />
        </dd>
        <dt class="font-semibold"><%= gettext "Distance" %></dt>
        <dd>
          <GearLive.stat stat={@gear.distance} format={:distance} />
        </dd>
        <dt class="font-semibold"><%= gettext "Elevation Gain" %></dt>
        <dd>
          <GearLive.stat stat={@gear.total_elevation_gain} format={:elevation} />
        </dd>
        <dt class="font-semibold"><%= gettext "Elapsed Time" %></dt>
        <dd>
          <GearLive.stat stat={@gear.elapsed_time} format={:duration} />
        </dd>
      </dl>
    </section>
    """
  end
end
