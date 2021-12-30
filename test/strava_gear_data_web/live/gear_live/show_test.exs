defmodule StravaGearDataWeb.GearLive.ShowTest do
  use StravaGearDataWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "mount/3" do
    setup [:authorize_password, :authorize_athlete]

    test "displays gear stats", %{conn: conn, athlete: athlete} do
      gear = insert(:gear, athlete: athlete)

      {:ok, view, _disconnected_html} = live(conn, Routes.gear_path(conn, :show, gear))

      assert view
             |> element("h1", gear.name)
             |> has_element?()

      assert view
             |> element("dt", "Activity Count")
             |> has_element?()

      assert view
             |> element("dt", "Distance")
             |> has_element?()

      assert view
             |> element("dt", "Elevation Gain")
             |> has_element?()

      assert view
             |> element("dt", "Elapsed Time")
             |> has_element?()
    end

    test "raises error if no gear found", %{conn: conn} do
      uuid = Ecto.UUID.generate()

      assert_raise Ecto.NoResultsError, fn ->
        {:ok, _view, _disconnected_html} = live(conn, Routes.gear_path(conn, :show, uuid))
      end
    end

    test "raises error gear doesn't belong to athlete", %{conn: conn} do
      gear = insert(:gear)

      assert_raise Ecto.NoResultsError, fn ->
        {:ok, _view, _disconnected_html} = live(conn, Routes.gear_path(conn, :show, gear))
      end
    end
  end
end
