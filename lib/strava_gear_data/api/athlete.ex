defmodule StravaGearData.Api.Athlete do
  @moduledoc """
  Representation of athlete returned by the api
  """
  defstruct [
    :id,
    :firstname,
    :lastname,
    :username,
    :profile_medium
  ]

  @type t :: %__MODULE__{
          id: integer(),
          firstname: String.t(),
          lastname: String.t(),
          username: String.t(),
          profile_medium: String.t()
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
end
