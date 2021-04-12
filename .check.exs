defmodule CheckConfigs do
  def credo_tool_config do
    if System.get_env("CI") do
      {:credo, command: "mix credo --format=flycheck"}
    else
      {:credo, true}
    end
  end
end

[
  ## all available options with default values (see `mix check` docs for description)
  # parallel: true,

  ## don't print info about skipped tools
  skipped: false,

  ## run tools in fix mode if not on CI.
  ## This will  automatically format and clean up unused deps right now.
  fix: if(System.get_env("CI"), do: false, else: true),
  tools: [
    {:npm_test, false},
    {:ex_unit,
     command: "mix do compile --warnings-as-errors, test --include feature_test",
     env: %{"MIX_ENV" => "test", "WARNINGS_AS_ERRORS" => "1"}},
    CheckConfigs.credo_tool_config()
  ]
]
