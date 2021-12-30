defmodule StravaGearDataWeb.GearLive.IndexTest do
  use StravaGearDataWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "mount/3" do
    setup [:authorize_password, :authorize_athlete]

    test ":index renders message when no athlete gear", %{conn: conn} do
      {:ok, gear_live, disconnected_html} = live(conn, Routes.gear_path(conn, :index))

      connected_html = render(gear_live)

      assert disconnected_html =~ "We are gathering your gear from Strava."

      assert connected_html =~ "We are gathering your gear from Strava."
    end

    test ":index renders athlete gear", %{conn: conn, athlete: athlete} do
      gear = insert_list(3, :gear, athlete: athlete)

      {:ok, gear_live, disconnected_html} = live(conn, Routes.gear_path(conn, :index))

      Enum.each(gear, fn g ->
        assert gear_live
               |> element("a", g.name)
               |> has_element?()

        assert disconnected_html =~ g.name
      end)
    end

    test "clicking gear name takes you to gear show page", %{conn: conn, athlete: athlete} do
      [first_gear | _] = insert_list(3, :gear, athlete: athlete)

      {:ok, gear_live, _disconnected_html} = live(conn, Routes.gear_path(conn, :index))

      assert gear_live
             |> element("a", first_gear.name)
             |> render_click()

      assert_redirected(gear_live, Routes.gear_path(conn, :show, first_gear))
    end
  end

  describe "handle_event/3" do
    setup [:authorize_password, :authorize_athlete]

    test "delete-athlete-data redirects when deletion successful", %{conn: conn} do
      {:ok, gear_live, _disconnected_html} = live(conn, Routes.gear_path(conn, :index))

      gear_live
      |> element("button", "Delete Data")
      |> render_click()

      assert_redirected(gear_live, Routes.auth_path(conn, :delete))
    end
  end
end
