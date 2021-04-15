defmodule StravaGearData.Athletes do
  @moduledoc """
  The Athletes context.
  """
  alias StravaGearData.Repo

  alias StravaGearData.Athletes.Athlete

  @doc """
  Gets a single athlete.

  Raises `Ecto.NoResultsError` if the Athlete does not exist.

  ## Examples

      iex> get_athlete!(123)
      %Athlete{}

      iex> get_athlete!(456)
      ** (Ecto.NoResultsError)

  """
  def get_athlete!(id), do: Repo.get!(Athlete, id)

  @doc """
  Creates a athlete.

  ## Examples

      iex> create_athlete(%{field: value})
      {:ok, %Athlete{}}

      iex> create_athlete(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_athlete(attrs \\ %{}) do
    %Athlete{}
    |> Athlete.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a athlete.

  ## Examples

      iex> update_athlete(athlete, %{field: new_value})
      {:ok, %Athlete{}}

      iex> update_athlete(athlete, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_athlete(%Athlete{} = athlete, attrs) do
    athlete
    |> Athlete.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a athlete.

  ## Examples

      iex> delete_athlete(athlete)
      {:ok, %Athlete{}}

      iex> delete_athlete(athlete)
      {:error, %Ecto.Changeset{}}

  """
  def delete_athlete(%Athlete{} = athlete) do
    Repo.delete(athlete)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking athlete changes.

  ## Examples

      iex> change_athlete(athlete)
      %Ecto.Changeset{data: %Athlete{}}

  """
  def change_athlete(%Athlete{} = athlete, attrs \\ %{}) do
    Athlete.changeset(athlete, attrs)
  end
end
