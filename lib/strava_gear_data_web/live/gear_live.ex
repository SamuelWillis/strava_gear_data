defmodule StravaGearDataWeb.GearLive do
  @moduledoc """
  GearLive Module to handle shared Gear page concerns.
  """
  use Phoenix.Component
  @seconds_in_hour 3600
  @seconds_in_minute 60

  @doc """
  A simple component to render formatted stat or `-` if stat is not truthy.

  Supported assigns:
  - stat: the stat to display
  - format: the optional format, supports `:duration`, `:elevation`, `:distance`.
  """
  def stat(assigns) do
    assigns = assign_new(assigns, :format, fn -> nil end)

    ~H"""
    <%= if @stat do %>
      <%= format(@format, @stat) %>
    <% else %>
        -
    <% end %>
    """
  end

  @doc false
  def format(:duration, seconds) do
    hours =
      seconds
      |> div(@seconds_in_hour)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    minutes =
      seconds
      |> rem(@seconds_in_hour)
      |> div(@seconds_in_minute)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    seconds =
      seconds
      |> rem(@seconds_in_hour)
      |> rem(@seconds_in_minute)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    "#{hours}:#{minutes}:#{seconds}"
  end

  def format(:elevation, meters) do
    meters =
      meters
      |> Decimal.from_float()
      |> Decimal.round(2)

    "#{meters}m"
  end

  def format(:distance, meters) do
    distance =
      meters
      |> Decimal.from_float()
      |> Decimal.div(1000)
      |> Decimal.round(2)

    "#{distance}km"
  end

  def format(_type, stat), do: stat
end
