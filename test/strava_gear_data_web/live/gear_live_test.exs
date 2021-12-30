defmodule StravaGearDataWeb.GearLiveTest do
  use StravaGearDataWeb.ConnCase, async: true

  alias StravaGearDataWeb.GearLive

  describe "stat/1" do
    test "renders stat" do
    end

    test "renders placeholder if stat is nil" do
    end
  end

  describe "format/2" do
    test "formats :duration correctly" do
      durations = [
        {1, "00:00:01"},
        {25, "00:00:25"},
        {60, "00:01:00"},
        {1800, "00:30:00"},
        {3600, "01:00:00"},
        {43_200, "12:00:00"},
        {4029, "01:07:09"},
        {217_736, "60:28:56"}
      ]

      for {duration, expected} <- durations do
        assert expected == GearLive.format(:duration, duration)
      end
    end

    test "formats :elevation correctly" do
      elevations = [
        {100.0, "100.00m"},
        {100.1, "100.10m"},
        {100.054321, "100.05m"},
        {100.056789, "100.06m"},
        {123.45, "123.45m"}
      ]

      for {elevation, expected} <- elevations do
        assert expected == GearLive.format(:elevation, elevation)
      end
    end

    test "formats :distance correctly" do
      distances = [
        {1.0, "0.00km"},
        {10.0, "0.01km"},
        {100.0, "0.10km"},
        {1000.0, "1.00km"},
        {123_456.0, "123.46km"},
        {123_456.0, "123.46km"},
        {123_4.0, "1.23km"},
        {123_4.0, "1.23km"}
      ]

      for {distance, expected} <- distances do
        assert expected == GearLive.format(:distance, distance)
      end
    end

    test "returns stat if format type unsupported" do
      stat = "My cool stat"
      assert stat == GearLive.format(:unsupported_type, stat)
    end
  end
end
