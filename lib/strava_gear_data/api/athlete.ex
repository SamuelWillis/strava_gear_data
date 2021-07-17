defmodule StravaGearData.Api.Athlete do
  @moduledoc """
  Representation of athlete returned by the api
  """
  defstruct [
    :id,
    :firstname,
    :lastname,
    :username,
    :profile_medium,
    bikes: [],
    shoes: []
  ]

  @type t :: %__MODULE__{
          id: integer(),
          firstname: String.t(),
          lastname: String.t(),
          username: String.t(),
          profile_medium: String.t(),
          bikes: [gear_t()] | nil,
          shoes: [gear_t()] | nil
        }

  @type gear_t :: %{
          id: String.t(),
          primary: boolean(),
          name: String.t(),
          distance: float()
        }

  def from!(%OAuth2.AccessToken{
        other_params: %{
          "athlete" => %{
            "id" => id,
            "firstname" => firstname,
            "lastname" => lastname,
            "username" => username,
            "profile_medium" => profile_medium
          }
        }
      }) do
    struct!(__MODULE__, %{
      id: id,
      firstname: firstname,
      lastname: lastname,
      username: username,
      profile_medium: profile_medium
    })
  end

  def from!(%{
        "id" => id,
        "firstname" => firstname,
        "lastname" => lastname,
        "username" => username,
        "profile_medium" => profile_medium,
        "bikes" => bikes,
        "shoes" => shoes
      }) do
    struct!(__MODULE__, %{
      id: id,
      firstname: firstname,
      lastname: lastname,
      username: username,
      profile_medium: profile_medium,
      bikes: gear_from!(bikes),
      shoes: gear_from!(shoes)
    })
  end

  def from!(_), do: nil

  def gear_from!(gear) when is_list(gear), do: Enum.map(gear, &gear_from!/1)

  def gear_from!(%{
        "id" => id,
        "primary" => primary,
        "name" => name,
        "distance" => distance
      }),
      do: %{
        id: id,
        primary: primary,
        name: name,
        distance: distance
      }
end
