defmodule StravaGearData.DataCollection.SupervisorTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.DataCollection.Supervisor

  setup do
    on_exit(fn ->
      StravaGearData.DataCollection.Supervisor
      |> Task.Supervisor.children()
      |> Enum.map(&Task.Supervisor.terminate_child(StravaGearData.DataCollection.Supervisor, &1))
    end)
  end

  describe "gather_athlete_data/1" do
    test "starts a child" do
      athlete = insert(:athlete)

      assert {:ok, pid} = Supervisor.gather_athlete_data(athlete)

      assert is_pid(pid)
    end
  end
end
