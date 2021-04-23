defmodule StravaGearData.Api.Token do
  @moduledoc """
  A struct to represent the OAuth2.AccessToken
  """
  alias StravaGearData.Api

  defstruct [
    :access_token,
    :expires_at,
    :token_type,
    :refresh_token,
    :other_params
  ]

  @type t :: %__MODULE__{
          access_token: String.t(),
          expires_at: integer(),
          token_type: String.t(),
          refresh_token: String.t(),
          other_params: other_params_t()
        }

  @type other_params_t() :: %{
          athlete: Api.Athlete.t()
        }

  def from!(
        %OAuth2.AccessToken{
          access_token: access_token,
          expires_at: expires_at,
          token_type: token_type,
          refresh_token: refresh_token
        } = token
      ) do
    struct!(__MODULE__, %{
      access_token: access_token,
      expires_at: expires_at,
      token_type: token_type,
      refresh_token: refresh_token,
      other_params: %{
        athlete: Api.Athlete.from!(token)
      }
    })
  end
end
