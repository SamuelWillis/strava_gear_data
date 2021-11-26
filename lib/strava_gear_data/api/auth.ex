defmodule StravaGearData.Api.Auth do
  @moduledoc """
  OAuth2 strategy for authenticating with the Strava API.

  [See OAuth2 docs](https://hexdocs.pm/oauth2/readme.html#write-your-own-strategy)
  """

  use OAuth2.Strategy

  alias OAuth2.Client

  def client(opts \\ []) do
    token = Keyword.get(opts, :token, nil)

    [
      authorize_url: "https://www.strava.com/oauth/authorize",
      client_id: config(:client_id),
      client_secret: config(:client_secret),
      redirect_uri: redirect_uri(Application.get_env(:strava_gear_data, :env)),
      site: "https://www.strava.com/api/v3",
      strategy: __MODULE__,
      token: token,
      token_url: "https://www.strava.com/oauth/token"
    ]
    |> Client.new()
    |> Client.put_serializer("application/json", Jason)
  end

  def access_token(params), do: OAuth2.AccessToken.new(params)

  def expired?(token), do: OAuth2.AccessToken.expired?(token)

  def authorize_url! do
    Client.authorize_url!(client(),
      scope: "read,activity:read,profile:read_all",
      approval_prompt: "force"
    )
  end

  def get_token!(params) do
    params = Keyword.put(params, :client_secret, System.get_env("STRAVA_CLIENT_SECRET"))

    Client.get_token!(client(), params, [], [])
  end

  def refresh_tokens!(client) do
    Client.refresh_token!(
      client,
      [
        client_id: System.get_env("STRAVA_CLIENT_ID"),
        client_secret: System.get_env("STRAVA_CLIENT_SECRET")
      ],
      [],
      []
    )
  end

  def get!(client, url, headers \\ [], opts \\ []) do
    OAuth2.Client.get!(client, url, headers, opts)
  end

  defp redirect_uri(:prod),
    do: "https://" <> System.get_env("APP_NAME") <> ".gigalixirapp.com/api/auth/callback"

  defp redirect_uri(_), do: "http://localhost:4000/api/auth/callback"

  defp config(key), do: :strava_gear_data |> Application.get_env(:api) |> Keyword.fetch!(key)

  # Callbacks
  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
