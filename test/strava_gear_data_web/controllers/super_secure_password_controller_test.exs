defmodule StravaGearDataWeb.SuperSecurePasswordControllerTest do
  use StravaGearDataWeb.ConnCase, async: true

  describe "new/2" do
    test "renders initial state correctly", %{conn: conn} do
      conn = get(conn, Routes.super_secure_password_path(conn, :new))

      assert response(conn, 200) =~ "Enter password"
    end
  end

  describe "create/2" do
    test "redirects to home if password correct", %{conn: conn} do
      attrs = %{
        super_secure_password: Application.get_env(:strava_gear_data, :super_secure_password)
      }

      conn =
        post(conn, Routes.super_secure_password_path(conn, :create),
          super_secure_password_params: attrs
        )

      assert redirected_to(conn) == Routes.gear_path(conn, :index)
    end

    test "redirects to password path if password incorrect", %{conn: conn} do
      attrs = %{
        super_secure_password: "bad-password"
      }

      conn =
        post(conn, Routes.super_secure_password_path(conn, :create),
          super_secure_password_params: attrs
        )

      assert response(conn, 200) =~ "Wrong Password"
    end
  end
end
