defmodule StravaGearDataWeb.AuthControllerTest do
  use StravaGearDataWeb.ConnCase, async: true

  import Mox

  alias StravaGearData.Authorization

  setup :verify_on_exit!

  describe "auth/2" do
    test "redirects strava auth route", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :auth))

      assert redirected_to(conn, 302) == Authorization.authorize_url!()
    end
  end

  describe "callback/2" do
    test "redirects to gear index when auth successful", %{conn: conn} do
      code = "fake-code"

      expect(StravaGearData.Api.MockClient, :exchange_code_for_token, fn code: ^code ->
        build(:api_token)
      end)

      expect(StravaGearData.DataCollection.MockSupervisor, :gather_athlete_data, fn _athlete ->
        :ok
      end)

      conn = get(conn, Routes.auth_path(conn, :callback), %{code: code})

      assert redirected_to(conn, 302) == Routes.gear_path(conn, :index)
    end

    test "redirects back to signup if auth cancelled", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :callback), %{})

      assert redirected_to(conn, 302) == Routes.auth_path(conn, :index)
    end
  end

  describe "delete/2" do
    setup :authorize_athlete

    test "redirects to auth index", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :delete), %{})

      assert redirected_to(conn, 302) == Routes.auth_path(conn, :index)
      assert get_flash(conn, :info) == "Your data was deleted"
    end
  end
end
