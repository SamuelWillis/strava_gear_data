defmodule StravaGearDataWeb.Live.Hooks.CheckPasswordProtection do
  @moduledoc """
  A Hook to ensure that the user has input the super secure password that protects
  the app.
  """

  alias StravaGearDataWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, %{"super_secure_password" => password}, socket) do
    super_secure_password = Application.get_env(:strava_gear_data, :super_secure_password)

    case Phoenix.Token.verify(
           StravaGearDataWeb.Endpoint,
           "super secure password",
           password,
           max_age: :infinity
         ) do
      {:ok, ^super_secure_password} ->
        {:cont, socket}

      _ ->
        socket =
          Phoenix.LiveView.redirect(socket, to: Routes.super_secure_password_path(socket, :new))

        {:halt, socket}
    end
  end
end
