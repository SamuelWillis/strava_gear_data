defmodule StravaGearData.AthletesTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Athletes
  alias StravaGearData.Athletes.AccessToken
  alias StravaGearData.Athletes.Athlete
  alias StravaGearData.Athletes.RefreshToken

  @access_token_params %{
    token: "access-token",
    expires_at: 1_999_140_711 |> DateTime.from_unix!() |> DateTime.truncate(:second),
    token_type: "Bearer"
  }

  @refresh_token_params %{
    token: "refresh-token"
  }

  @valid_attrs %{
    strava_id: 123,
    first_name: "Test",
    last_name: "Athlete",
    username: "testathlete",
    profile_picture: "https://profile.picture/of/athlete",
    access_token: @access_token_params,
    refresh_token: @refresh_token_params
  }

  @update_attrs %{
    first_name: "New",
    last_name: "Name",
    username: "newtestathlete",
    profile_picture: "https://new.profile.picture/of/athlete"
  }

  describe "get_athlete/1" do
    test "get_athlete!/1 returns the athlete with given id" do
      athlete = insert(:athlete)
      assert Athletes.get_athlete!(athlete.id) == athlete
    end
  end

  describe "get_athlete_by_strava_id/1" do
    test "returns the athlete with given strava id" do
      athlete = insert(:athlete, strava_id: 1234)
      assert Athletes.get_athlete_by_strava_id(athlete.strava_id) == athlete
    end

    test "returns nil if no athlete with given strava_id" do
      assert is_nil(Athletes.get_athlete_by_strava_id(1234))
    end
  end

  describe "create_athlete/1" do
    test "valid data creates an athlete" do
      assert {:ok, %Athlete{} = athlete} = Athletes.create_athlete(@valid_attrs)

      assert athlete.strava_id == @valid_attrs.strava_id
    end

    test "valid data creates athlete access token" do
      assert {:ok, %Athlete{} = athlete} = Athletes.create_athlete(@valid_attrs)

      assert %AccessToken{} = athlete.access_token
    end

    test "valid data creates athlete refresh token" do
      assert {:ok, %Athlete{} = athlete} = Athletes.create_athlete(@valid_attrs)

      assert %RefreshToken{} = athlete.refresh_token
    end

    test "missing access token returns error changeset" do
      attrs = %{
        strava_id: 1,
        refresh_token: @refresh_token_params
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Athletes.create_athlete(attrs)

      refute changeset.valid?

      assert "can't be blank" in errors_on(changeset).access_token
    end

    test "missing refresh token returns error changeset" do
      attrs = %{
        strava_id: 1,
        access_token: @access_token_params
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Athletes.create_athlete(attrs)

      refute changeset.valid?

      assert "can't be blank" in errors_on(changeset).refresh_token
    end

    test "duplicate strava id returns error changeset" do
      athlete = insert(:athlete)

      attrs = %{
        strava_id: athlete.strava_id,
        access_token: @access_token_params,
        refresh_token: @refresh_token_params
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Athletes.create_athlete(attrs)

      refute changeset.valid?

      assert "has already been taken" in errors_on(changeset).strava_id
    end
  end

  describe "update_athlete/2" do
    setup do
      athlete = :athlete |> build() |> with_tokens() |> insert()

      %{athlete: athlete}
    end

    test "valid data updates the athlete", %{athlete: athlete} do
      assert {:ok, %Athlete{}} = Athletes.update_athlete(athlete, @update_attrs)
    end

    test "returns error changeset if strava id updated to existing strava id", %{athlete: athlete} do
      %{strava_id: taken_strava_id} = insert(:athlete)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Athletes.update_athlete(athlete, %{strava_id: taken_strava_id})

      refute changeset.valid?

      assert "has already been taken" in errors_on(changeset).strava_id
    end
  end

  describe "delete_athlete/1" do
    setup do
      athlete = :athlete |> build() |> with_tokens() |> with_gear(3) |> insert()

      %{athlete: athlete}
    end

    test "deletes the athlete", %{athlete: athlete} do
      assert {:ok, %Athlete{}} = Athletes.delete_athlete(athlete)

      assert_raise Ecto.NoResultsError, fn ->
        Athletes.get_athlete!(athlete.id)
      end
    end

    test "deletes the athlete tokens", %{athlete: athlete} do
      assert {:ok, %Athlete{}} = Athletes.delete_athlete(athlete)

      assert_raise Ecto.NoResultsError, fn ->
        Repo.get!(AccessToken, athlete.access_token.id)
      end

      assert_raise Ecto.NoResultsError, fn ->
        Repo.get!(RefreshToken, athlete.refresh_token.id)
      end
    end

    test "deletes the athlete gear", %{athlete: athlete} do
      assert {:ok, %Athlete{}} = Athletes.delete_athlete(athlete)

      assert [] == StravaGearData.Gear.get_for!(athlete)
    end
  end

  describe "change_athlete/1" do
    test "returns a athlete changeset" do
      athlete = :athlete |> build() |> with_tokens() |> insert()
      assert %Ecto.Changeset{} = Athletes.change_athlete(athlete)
    end
  end
end
