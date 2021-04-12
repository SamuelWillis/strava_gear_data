defmodule StravaGearData.Api do
  alias StravaGearData.Api

  defdelegate authorize_url!, to: Api.Auth

  defdelegate get_token!(params), to: Api.Auth
end
