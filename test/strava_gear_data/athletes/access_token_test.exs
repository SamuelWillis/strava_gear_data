defmodule StravaGearData.Athletes.AccessTokenTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Athletes.AccessToken

  describe "changeset/2" do
    test "requires all fields" do
      changeset = AccessToken.changeset(%AccessToken{}, %{})

      refute changeset.valid?, inspect(changeset)

      assert "can't be blank" in errors_on(changeset).athlete_id
      assert "can't be blank" in errors_on(changeset).expires_at
      assert "can't be blank" in errors_on(changeset).token
      assert "can't be blank" in errors_on(changeset).token_type
    end

    test "requires existing athlete in DB" do
      attrs = %{
        athlete_id: Ecto.UUID.generate(),
        token: "fake-token",
        token_type: "Bearer",
        expires_at: DateTime.truncate(DateTime.utc_now(), :second)
      }

      assert {:error, changeset} =
               %AccessToken{}
               |> AccessToken.changeset(attrs)
               |> Repo.insert()

      refute changeset.valid?, inspect(changeset)

      assert "does not exist" in errors_on(changeset).athlete
    end

    test "does not allow multiple tokens per athlete" do
      athlete = :athlete |> build() |> with_access_token() |> insert()

      attrs = %{
        athlete_id: athlete.id,
        token: "new-token",
        token_type: "Bearer",
        expires_at: DateTime.truncate(DateTime.utc_now(), :second)
      }

      assert {:error, changeset} =
               %AccessToken{}
               |> AccessToken.changeset(attrs)
               |> Repo.insert()

      refute changeset.valid?, inspect(changeset)

      assert "has already been taken" in errors_on(changeset).athlete_id
    end
  end
end
