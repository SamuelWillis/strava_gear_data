defmodule StravaGearData.AuthorizationTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Api
  alias StravaGearData.Athletes.Athlete
  alias StravaGearData.Authorization

  @expires_at_datetime DateTime.from_unix!(1_618_987_211)

  @athlete_attrs %{
    strava_id: 7_660_837,
    first_name: "Samuel",
    last_name: "Willis",
    username: "samuelwillis",
    profile_picture:
      "https://dgalywyr863hv.cloudfront.net/pictures/athletes/7660837/5433166/1/medium.jpg",
    refresh_token: %{
      token: "fake-refresh-token"
    },
    access_token: %{
      token: "fake-access-token",
      expires_at: @expires_at_datetime,
      token_type: "Bearer"
    }
  }

  describe "insert_or_update_athlete/1" do
    test "inserts athlete if no athlete for strava_id" do
      assert {:ok, %Athlete{}} = Authorization.insert_or_update_athlete(@athlete_attrs)
    end

    test "updates athlete if athlete for strava_id" do
      insert(:athlete, strava_id: @athlete_attrs.strava_id)
      assert {:ok, %Athlete{}} = Authorization.insert_or_update_athlete(@athlete_attrs)
    end
  end

  @api_athlete %Api.Athlete{
    firstname: "Samuel",
    id: 7_660_837,
    lastname: "Willis",
    profile_medium:
      "https://dgalywyr863hv.cloudfront.net/pictures/athletes/7660837/5433166/1/medium.jpg",
    username: "samuelwillis"
  }

  @api_token %Api.Token{
    access_token: "fake-access-token",
    expires_at: 1_618_987_211,
    other_params: %{
      athlete: @api_athlete
    },
    refresh_token: "fake-refresh-token",
    token_type: "Bearer"
  }

  describe "build_athlete_attrs/1" do
    test "builds expected athlete attrs" do
      result = Authorization.build_athlete_attrs(@api_token)

      assert %{
               strava_id: 7_660_837,
               first_name: "Samuel",
               last_name: "Willis",
               username: "samuelwillis",
               profile_picture:
                 "https://dgalywyr863hv.cloudfront.net/pictures/athletes/7660837/5433166/1/medium.jpg"
             } = result
    end
  end

  describe "put_access_token_attrs/2" do
    test "puts access token attrs into athlete attrs" do
      result = Authorization.put_access_token_attrs(%{}, @api_token)

      assert %{
               access_token: %{
                 token: "fake-access-token",
                 expires_at: @expires_at_datetime,
                 token_type: "Bearer"
               }
             } = result
    end
  end

  describe "put_refresh_token_attrs/2" do
    test " puts refresh token into athlete attrs" do
      result = Authorization.put_refresh_token_attrs(%{}, @api_token)

      assert %{
               refresh_token: %{
                 token: "fake-refresh-token"
               }
             } = result
    end
  end
end
