# Ensure ExMachina is running
{:ok, _} = Application.ensure_all_started(:ex_machina)

Mox.defmock(StravaGearData.Api.MockClient, for: StravaGearData.Api.Client)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(StravaGearData.Repo, :manual)
