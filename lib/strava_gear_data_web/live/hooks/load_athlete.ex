defmodule StravaGearDataWeb.Live.Hooks.LoadAthlete do
  @moduledoc """
  A hook to load the athlete from the session token
  """
  import Phoenix.LiveView

  alias StravaGearData.Athletes

  def on_mount(:default, _params, %{"token" => token}, socket) do
    {:ok, athlete_id} =
      Phoenix.Token.verify(StravaGearDataWeb.Endpoint, "athlete auth", token, max_age: :infinity)

    athlete = Athletes.get_athlete!(athlete_id)

    socket = assign(socket, :athlete, athlete)

    {:cont, socket}
  end
end
