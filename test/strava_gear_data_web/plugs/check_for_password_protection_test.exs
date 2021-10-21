defmodule StravaGearGearDataWeb.Plugs.CheckPasswordProtesctionTest do
  use StravaGearDataWeb.ConnCase, async: true

  alias StravaGearDataWeb.Plugs.CheckPasswordProtection

  test "continues when valid password in session", %{conn: conn} do
    super_secure_password = Application.get_env(:strava_gear_data, :super_secure_password)

    password_token =
      Phoenix.Token.sign(
        StravaGearDataWeb.Endpoint,
        "super secure password",
        super_secure_password
      )

    conn =
      conn
      |> init_test_session(%{super_secure_password: password_token})
      |> CheckPasswordProtection.call(%{})

    refute conn.halted
  end

  test "redirects when bad password token in session", %{conn: conn} do
    password_token =
      Phoenix.Token.sign(StravaGearDataWeb.Endpoint, "super secure password", "wrong-password")

    conn =
      conn
      |> init_test_session(%{super_secure_password: password_token})
      |> CheckPasswordProtection.call(%{})

    assert conn.halted

    assert redirected_to(conn, 302) == "/password"
  end

  test "redirects when no password token in session", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{})
      |> CheckPasswordProtection.call(%{})

    assert conn.halted

    assert redirected_to(conn, 302) == "/password"
  end
end
