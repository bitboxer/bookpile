defmodule Bookpile.MixProject do
  use Mix.Project

  def project do
    [
      app: :bookpile,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  def application do
    [
      mod: {Bookpile.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.8"},
      {:phoenix_ecto, "~> 4.7"},
      {:ecto_sql, "~> 3.14"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.3"},
      {:phoenix_live_reload, "~> 1.6", only: :dev},
      {:phoenix_live_view, "~> 1.1"},
      {:floki, "~> 0.38"},
      {:phoenix_live_dashboard, "~> 0.8.7"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.25"},
      {:bandit, "~> 1.11"},
      {:telemetry_metrics, "~> 1.1"},
      {:telemetry_poller, "~> 1.3"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:ex_check, ">= 0.0.0", only: :dev, runtime: false},
      {:httpoison, "~> 2.3"},
      {:mix_test_watch, "~> 1.4", only: :dev, runtime: false},
      {:credo, "~> 1.7"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
