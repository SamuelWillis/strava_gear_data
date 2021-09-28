defmodule StravaGearDataWeb.GearLiveTest do
  use StravaGearDataWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "disconnected and connected mount" do
    setup [:authorize_password, :authorize_athlete]

    test "renders message when no athlete gear", %{conn: conn, athlete: athlete} do
      {:ok, gear_live, disconnected_html} = live(conn, "/")

      connected_html = render(gear_live)

      assert disconnected_html =~ "Welcome, #{athlete.first_name}"
      assert disconnected_html =~ "We are gathering your gear from Strava."

      assert connected_html =~ "Welcome, #{athlete.first_name}"
      assert connected_html =~ "We are gathering your gear from Strava."
    end

    test "renders athlete gear", %{conn: conn, athlete: athlete} do
      gear = insert_list(3, :gear, athlete: athlete)

      {:ok, gear_live, disconnected_html} = live(conn, "/")

      connected_html = render(gear_live)

      assert disconnected_html =~ "Welcome, #{athlete.first_name}"

      assert connected_html =~ "Welcome, #{athlete.first_name}"

      Enum.each(gear, fn g ->
        assert disconnected_html =~ g.name
        assert connected_html =~ g.name
      end)
    end
  end

  describe "handle_event/3" do
    setup [:authorize_password, :authorize_athlete]

    test "delete-athlete-data redirects when deletion successful", %{conn: conn} do
      {:ok, gear_live, _disconnected_html} = live(conn, "/")

      gear_live
      |> element("button", "Delete Data")
      |> render_click()

      assert_redirected(gear_live, Routes.auth_path(conn, :delete))
    end
  end
end
