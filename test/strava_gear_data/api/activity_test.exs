defmodule StravaGearData.Api.ActivityTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Api

  @api_activity_data %{
    "timezone" => "(GMT-07:00) America/Edmonton",
    "id" => 6_138_681_847,
    "manual" => false,
    "average_watts" => 140.9,
    "display_hide_heartrate_option" => true,
    "start_latitude" => 49.49,
    "upload_id" => 6_523_518_421,
    "average_heartrate" => 154.7,
    "upload_id_str" => "6523518421",
    "type" => "Ride",
    "elapsed_time" => 7477,
    "from_accepted_tag" => false,
    "average_temp" => 8,
    "total_photo_count" => 0,
    "average_speed" => 3.251,
    "location_country" => "Canada",
    "has_heartrate" => true,
    "pr_count" => 3,
    "heartrate_opt_out" => false,
    "start_date_local" => "2021-10-19T16:04:09Z",
    "commute" => false,
    "kudos_count" => 8,
    "suffer_score" => 168.0,
    "location_city" => nil,
    "visibility" => "everyone",
    "athlete_count" => 1,
    "total_elevation_gain" => 481.0,
    "elev_low" => 991.4,
    "start_longitude" => -115.06,
    "start_latlng" => [49.49, -115.06],
    "utc_offset" => -2.16e4,
    "achievement_count" => 8,
    "moving_time" => 5881,
    "athlete" => %{"id" => 7_660_837, "resource_state" => 1},
    "distance" => 19_120.1,
    "has_kudoed" => false,
    "private" => false,
    "workout_type" => 10,
    "start_date" => "2021-10-19T22:04:09Z",
    "location_state" => nil,
    "kilojoules" => 828.4,
    "end_latlng" => [49.49, -115.06],
    "max_speed" => 13.1,
    "gear_id" => "b7460413",
    "resource_state" => 2,
    "comment_count" => 0,
    "map" => %{
      "id" => "a6138681847",
      "resource_state" => 2,
      "summary_polyline" =>
        "mqamH~ag}TTDTjAkBvCg@rAeAbHqAbF[zDGxDi@`FWXiBi@aA?QFu@jAXlCt@|A|@xCMvDc@lBO@s@]Sn@mAlAmF|Bs@g@{@iBeAgAqBwDs@q@oCgAiCQ{@JqDlAgBfA}BtBcCzC}C|Ei@?C_Ay@eBP@jGdNlCjFzKnVvCzHlCpFpD|Er@l@xCjAtBXdAl@q@dG?j@U`ABLYjDRjFV|A@tAZjEh@NrDBjs@Pp@PBtAc@rMYnFq@dGOrFIhAYdA]f@cAz@oBhCYdEBjHGnDWhD?rAc@bAKtBk@dD{@zCJt@Eb@@z@EG@}AOg@N`@LhBCf@I?Fa@CPPQQi@@Nj@vDJdFx@N~DrBP?bAaA|Ai@pCJnAh@pA~@lDdAbChFAt@WbBh@hCET^n@r@pBRrDZb@rBn@zCfB\\h@VFv@tBj@XpABfAVp@^jBMt@\\lDVTV|@Lr@Vf@d@dFpAn@b@dAXf@IlAjAb@ClAlAn@fAn@h@\\t@xA|AnC|AdCdArATb@zA~@nBjA@lBcATi@Fm@YgEiBuDcAoEoAwCc@sBeAaC?i@m@aAqF_FiBaAwCeAcAEaCq@oCW_A@eC_AcAwAEy@_@iA{AiAgAXwAvB{@RgBbAc@BeBdDuAHKz@g@i@u@yAB]Sg@SuAB_ABJFALUNo@^w@\\{A@cAYg@C[Bs@X_AfAmA~BoDDe@GU?q@g@s@g@}B`@c@d@mAF{@\\SGkBaCoEIyBm@k@yABQEKWlAeD\\kABUQ?COXm@B{@CWMB_@f@qBzAQKh@uEYQ[JVuA[QES\\wBBs@{AJuAtAGO?q@IEyB~CA]KGcBt@cAFu@j@SQy@R_@mAYUJ]z@i@^i@d@Mp@aA~@R\\c@FeAMiAo@mAWgA_@CGYJgACoAv@y@Ni@?m@c@q@yAOSH}@w@iA\\wBGuAp@q@Ub@_HZyGPuLGqBYS_BGiw@QQ{@q@iOB}A`A_NAc@{@g@}Ce@oBcAcBwAiBiCa@_@e@qA_A_BeCuF]oAeOq\\{G_O{@oAAXj@dAFd@An@p@GpCgEvGoHnAs@tEwA|BBtDnA~AfBbApBPp@h@RdAnBv@f@~C{@dBu@^o@^SZ}@r@`@NGl@_DBmCmBuF[gCz@oA|@GfB`@XUj@yEFeFPkB|AoGt@kGJa@tCqEUmASMIP"
    },
    "max_heartrate" => 190.0,
    "photo_count" => 0,
    "elev_high" => 1333.2,
    "trainer" => false,
    "name" => "168 - NEW GOAT",
    "external_id" => "garmin_push_7685762284",
    "flagged" => false,
    "device_watts" => false
  }

  describe "from!/1" do
    test "returns an activity from api data" do
      assert %Api.Activity{} = activity = Api.Activity.from!(@api_activity_data)

      assert activity.id == 6_138_681_847
      assert activity.name == "168 - NEW GOAT"
      assert activity.type == "Ride"
      assert activity.achievement_count == 8
      assert activity.distance == 19_120.1
      assert activity.average_speed == 3.251
      assert activity.max_speed == 13.1
      assert activity.total_elevation_gain == 481.0
      assert activity.elapsed_time == 7477
      assert activity.moving_time == 5881
      assert activity.start_date_local == "2021-10-19T16:04:09Z"
      assert activity.timezone == "(GMT-07:00) America/Edmonton"
      assert activity.gear_id == "b7460413"
    end
  end
end
