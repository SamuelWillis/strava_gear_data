defmodule StravaGearDataWeb.Router do
  use StravaGearDataWeb, :router

  alias StravaGearDataWeb.Plugs
  alias StravaGearDataWeb.Live.Hooks

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StravaGearDataWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/password", StravaGearDataWeb do
    pipe_through([:browser])

    get "/", SuperSecurePasswordController, :new
    post "/", SuperSecurePasswordController, :create
  end

  scope "/", StravaGearDataWeb do
    pipe_through([:browser, Plugs.CheckPasswordProtection, Plugs.EnsureToken])

    live_session :gear, on_mount: [Hooks.CheckPasswordProtection, Hooks.LoadAthlete] do
      live "/", GearLive.Index, :index, as: :gear
    end
  end

  scope "/signup", StravaGearDataWeb do
    pipe_through([:browser, Plugs.CheckPasswordProtection, Plugs.EnsureNoToken])

    live "/", AuthLive, :index
  end

  scope "/api", StravaGearDataWeb do
    pipe_through(:api)

    scope path: "/auth" do
      get "/", AuthController, :auth
      get "/callback", AuthController, :callback
      get "/delete", AuthController, :delete
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", StravaGearDataWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: StravaGearDataWeb.Telemetry
    end
  end
end
