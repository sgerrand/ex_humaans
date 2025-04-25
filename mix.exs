defmodule Humaans.MixProject do
  use Mix.Project

  @repo_url "https://github.com/sgerrand/ex_humaans"
  @version "0.4.0"

  def project do
    [
      app: :humaans,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),

      # Hex
      package: package(),
      description: "HTTP client for the Humaans API.",

      # Docs
      name: "Humaans",
      source_url: @repo_url,
      homepage_url: @repo_url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:exconstructor, "~> 1.2.11"},
      {:req, "~> 0.5.6"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:expublish, "~> 2.5", only: [:dev], runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url,
        "Changelog" => "https://hexdocs.pm/humaans/changelog.html"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @repo_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end
end
