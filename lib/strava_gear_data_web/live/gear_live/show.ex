defmodule StravaGearDataWeb.GearLive.Show do
  @moduledoc false
  use StravaGearDataWeb, :live_view

  alias StravaGearData.Gear
  alias StravaGearData.Stats
  alias StravaGearDataWeb.GearLive

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    %{athlete: athlete} = socket.assigns

    gear = Gear.get_athlete_gear!(athlete, id)

    stats = Stats.weekly_stats(gear)

    socket =
      socket
      |> assign(:gear, gear)
      |> assign(:stats, stats)
      |> push_event(:points, %{points: format_weekly_stat(stats, :distance)})

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section>
      <header>
        <h1><%= @gear.name %></h1>
      </header>

      <div id="chart" class="container" phx-hook="Chart" />

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

  defp format_weekly_stat(stats, :distance) do
    dates =
      Enum.map(stats, fn stat ->
        stat.week
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix()
      end)

    distances = Enum.map(stats, fn stat -> stat.distance / 1000 end)

    [dates, distances]
  end
end
