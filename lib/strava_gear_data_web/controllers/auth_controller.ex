defmodule StravaGearDataWeb.AuthController do
  use StravaGearDataWeb, :controller

  alias StravaGearData.Authorization
  alias StravaGearData.DataCollection

  plug :fetch_session when action in [:callback, :delete]
  plug :fetch_flash when action in [:callback, :delete]

  def auth(conn, _params) do
    redirect(conn, external: Authorization.authorize_url!())
  end

  def callback(conn, %{"code" => code}) do
    {:ok, athlete} = Authorization.authorize_athlete_from!(code: code)

    session_token = Phoenix.Token.sign(StravaGearDataWeb.Endpoint, "athlete auth", athlete.id)

    DataCollection.gather_athlete_gear(athlete)

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

  def delete(conn, _params) do
    conn
    |> fetch_session()
    |> put_session(:token, nil)
    |> put_flash(:info, gettext("Your data was deleted"))
    |> redirect(to: Routes.auth_path(conn, :index))
  end
end
