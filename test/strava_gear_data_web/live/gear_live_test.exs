defmodule StravaGearDataWeb.GearLiveTest do
  use StravaGearDataWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    conn = Phoenix.ConnTest.init_test_session(conn, %{token: "my fake token"})

    {:ok, gear_live, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "Hello"
    assert render(gear_live) =~ "Hello"
  end
end
