# Ensure ExMachina is running
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(StravaGearData.Repo, :manual)
