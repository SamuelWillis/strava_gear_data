defmodule StravaGearDataWeb.AuthController do
  use StravaGearDataWeb, :controller

  alias StravaGearData.Authorization

  plug :fetch_session when action in [:callback]
  plug :fetch_flash when action in [:callback]

  def auth(conn, _params) do
    redirect(conn, external: Authorization.authorize_url!())
  end

  def callback(conn, %{"code" => code}) do
    {:ok, athlete} = Authorization.authorize_new_athlete_from!(code: code)
    session_token = Phoenix.Token.sign(StravaGearDataWeb.Endpoint, "athlete auth", athlete.id)

    conn
    |> put_flash(
      :info,
      "Successfully authorized your account. We are now fetching your data which can take a little while."
    )
    |> put_session(:token, session_token)
    |> redirect(to: Routes.gear_path(conn, :index))
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:warning, "Unable to authenticate with Strava. Please try again")
    |> redirect(to: Routes.auth_path(conn, :index))
  end
end
