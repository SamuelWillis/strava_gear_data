defmodule StravaGearDataWeb.Plugs.EnsureToken do
  @moduledoc """
  Plug to ensure that an auth token appears in the session.

  Used on routes that require an authenticated athlete.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :token) do
      token when is_binary(token) ->
        conn

      nil ->
        conn
        |> Phoenix.Controller.redirect(to: "/signup")
        |> halt()
    end
  end
end
