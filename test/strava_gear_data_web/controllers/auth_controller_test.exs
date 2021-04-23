defmodule StravaGearDataWeb.AuthControllerTest do
  use StravaGearDataWeb.ConnCase, async: true

  alias StravaGearData.Authorization

  describe "auth/2" do
    test "redirects strava auth route", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :auth))

      assert redirected_to(conn, 302) == Authorization.authorize_url!()
    end
  end

  describe "callback/2" do
    test "redirects back to signup if auth cancelled", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :callback), %{})

      assert redirected_to(conn, 302) == Routes.auth_path(conn, :index)
    end
  end
end
