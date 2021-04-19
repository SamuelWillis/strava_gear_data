defmodule StravaGearData.Athletes.RefreshTokenTest do
  use StravaGearData.DataCase, async: true

  alias StravaGearData.Athletes.RefreshToken

  describe "changeset/2" do
    test "requires all fields" do
      changeset = RefreshToken.changeset(%RefreshToken{}, %{})

      refute changeset.valid?, inspect(changeset)

      assert "can't be blank" in errors_on(changeset).token
    end

    test "requires existing athlete in DB" do
      attrs = %{
        athlete_id: Ecto.UUID.generate(),
        token: "fake-token"
      }

      assert {:error, changeset} =
               %RefreshToken{}
               |> RefreshToken.changeset(attrs)
               |> Repo.insert()

      refute changeset.valid?, inspect(changeset)

      assert "does not exist" in errors_on(changeset).athlete
    end

    test "does not allow multiple tokens per athlete" do
      athlete = :athlete |> build() |> with_refresh_token() |> insert()

      attrs = %{
        athlete_id: athlete.id,
        token: "new-token"
      }

      assert {:error, changeset} =
               %RefreshToken{}
               |> RefreshToken.changeset(attrs)
               |> Repo.insert()

      refute changeset.valid?, inspect(changeset)

      assert "has already been taken" in errors_on(changeset).athlete_id
    end
  end
end
