defmodule StravaGearDataWeb.Components do
  @moduledoc false
  use StravaGearDataWeb, :component

  def athlete_nav(assigns) do
    ~H"""
    <nav class="container mx-auto py-2 flex items-center">
      <figure>
        <img
          class="rounded"
          src={@athlete.profile_picture}
          alt="Athlete profile picture"
        />
      </figure>
      <header>
        <h1 class="ml-4">
          <%= gettext "Welcome, %{first_name}", first_name: @athlete.first_name %>
        </h1>
      </header>
    </nav>
    """
  end
end
