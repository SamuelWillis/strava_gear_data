defmodule StravaGearDataWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use StravaGearDataWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import StravaGearData.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import StravaGearDataWeb.ConnCase
      import StravaGearData.Factory

      alias StravaGearDataWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint StravaGearDataWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(StravaGearData.Repo)

    Mox.stub_with(
      StravaGearData.DataCollection.MockSupervisor,
      StravaGearData.DataCollection.StubSupervisor
    )

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(StravaGearData.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def authorize_password(%{conn: conn}) do
    super_secure_password = Application.get_env(:strava_gear_data, :super_secure_password)

    password_token =
      Phoenix.Token.sign(
        StravaGearDataWeb.Endpoint,
        "super secure password",
        super_secure_password
      )

    conn =
      conn
      |> Phoenix.ConnTest.init_test_session(%{})
      |> Plug.Conn.put_session(:super_secure_password, password_token)

    %{conn: conn}
  end

  def authorize_athlete(%{conn: conn}) do
    athlete = :athlete |> build() |> with_profile() |> insert()
    session_token = Phoenix.Token.sign(StravaGearDataWeb.Endpoint, "athlete auth", athlete.id)

    conn =
      conn
      |> Phoenix.ConnTest.init_test_session(%{})
      |> Plug.Conn.put_session(:token, session_token)

    %{conn: conn, athlete: athlete}
  end
end
