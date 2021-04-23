defmodule StravaGearData.Api.AthleteTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Api

  @token %OAuth2.AccessToken{
    access_token: "fake-access-token",
    expires_at: 1_618_987_211,
    other_params: %{
      "athlete" => %{
        "badge_type_id" => 1,
        "bio" => nil,
        "city" => "Victoria",
        "country" => "Canada",
        "created_at" => "2015-01-18T21:43:16Z",
        "firstname" => "Samuel",
        "follower" => nil,
        "friend" => nil,
        "id" => 7_660_837,
        "lastname" => "Willis",
        "premium" => true,
        "profile" =>
          "https://dgalywyr863hv.cloudfront.net/pictures/athletes/7660837/5433166/1/large.jpg",
        "profile_medium" =>
          "https://dgalywyr863hv.cloudfront.net/pictures/athletes/7660837/5433166/1/medium.jpg",
        "resource_state" => 2,
        "sex" => "M",
        "state" => "BC",
        "summit" => true,
        "updated_at" => "2021-04-04T21:13:53Z",
        "username" => "samuelwillis",
        "weight" => 86.7
      },
      "expires_at" => 1_618_987_211
    },
    refresh_token: "fake-refresh-token",
    token_type: "Bearer"
  }

  describe "from!/1" do
    test "returns athlete from api token data" do
      assert %Api.Athlete{} = athlete = Api.Athlete.from!(@token)

      assert "Samuel" == athlete.firstname
      assert "Willis" == athlete.lastname
      assert "samuelwillis" == athlete.username

      assert "https://dgalywyr863hv.cloudfront.net/pictures/athletes/7660837/5433166/1/medium.jpg" ==
               athlete.profile_medium
    end
  end
end
