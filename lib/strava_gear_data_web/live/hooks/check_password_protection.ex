defmodule StravaGearDataWeb.Live.Hooks.CheckPasswordProtection do
  @moduledoc """
  A Hook to ensure that the user has input the super secure password that protects
  the app.
  """

  alias StravaGearDataWeb.Router.Helpers, as: Routes

  @super_secure_password Application.compile_env!(:strava_gear_data, :super_secure_password)

  def mount(_params, %{"super_secure_password" => super_secure_password}, socket)
      when is_binary(super_secure_password) do
    {:ok, @super_secure_password} =
      Phoenix.Token.verify(
        StravaGearDataWeb.Endpoint,
        "super secure password",
        super_secure_password,
        max_age: :infinity
      )

    {:cont, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      Phoenix.LiveView.redirect(socket, to: Routes.super_secure_password_path(socket, :new))

    {:halt, socket}
  end
end
