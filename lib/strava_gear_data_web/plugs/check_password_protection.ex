defmodule StravaGearDataWeb.Plugs.CheckPasswordProtection do
  @moduledoc """
  Checks the person accessing the application has filled out the
  super secure (TM) password prompt
  """
  import Plug.Conn

  alias StravaGearDataWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    super_secure_password = Application.get_env(:strava_gear_data, :super_secure_password)

    with password when is_binary(password) <-
           get_session(conn, :super_secure_password),
         {:ok, ^super_secure_password} <-
           Phoenix.Token.verify(StravaGearDataWeb.Endpoint, "super secure password", password,
             max_age: :infinity
           ) do
      conn
    else
      _ ->
        conn
        |> Phoenix.Controller.redirect(to: Routes.super_secure_password_path(conn, :new))
        |> halt()
    end
  end
end
