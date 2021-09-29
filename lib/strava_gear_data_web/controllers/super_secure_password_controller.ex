defmodule StravaGearDataWeb.SuperSecurePasswordController do
  use StravaGearDataWeb, :controller

  alias Ecto.Changeset

  @data %{}
  @types %{super_secure_password: :string}
  @super_secure_password Application.compile_env!(:strava_gear_data, :super_secure_password)

  def new(conn, _params) do
    render(conn, "new.html", changeset: password_changeset())
  end

  def create(conn, %{"super_secure_password_params" => attrs}) do
    changeset =
      attrs
      |> password_changeset()
      |> Map.put(:action, :insert)

    case changeset.valid? do
      true ->
        super_secure_password_token =
          Phoenix.Token.sign(
            StravaGearDataWeb.Endpoint,
            "super secure password",
            @super_secure_password
          )

        conn
        |> put_session(:super_secure_password, super_secure_password_token)
        |> redirect(to: "/")

      false ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp password_changeset(params \\ %{}) do
    {@data, @types}
    |> Changeset.cast(params, [:super_secure_password])
    |> Changeset.validate_required(:super_secure_password)
    |> Changeset.validate_change(:super_secure_password, &validate_super_secure_password/2)
  end

  defp validate_super_secure_password(_field, value) when value != @super_secure_password,
    do: [super_secure_password: "Wrong Password"]

  defp validate_super_secure_password(_field, _value), do: []
end
