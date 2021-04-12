defmodule StravaGearDataWeb.Plugs.EnsureNoToken do
  @moduledoc """
  Ensures no auth token appears in the session.

  Used on routes that are for initializing authorization.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :token) do
      token when is_binary(token) ->
        conn
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      nil ->
        conn
    end
  end
end
