defmodule PhoenixSwoosh.Mixfile do
  use Mix.Project

  @source_url "https://github.com/swoosh/phoenix_swoosh"
  @version "1.2.1"

  def project do
    [
      app: :phoenix_swoosh,
      version: @version,
      elixir: "~> 1.11",
      name: "Phoenix.Swoosh",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      preferred_cli_env: [docs: :docs]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:swoosh, "~> 1.5"},
      {:phoenix_view, "~> 1.0 or ~> 2.0"},
      {:phoenix_html, "~> 3.0 or ~> 4.0", optional: true},
      {:hackney, "~> 1.10", optional: true},
      {:finch, "~> 0.8", optional: true},
      {:phoenix, "~> 1.8", optional: true},
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.26", only: :docs, runtime: false}
    ]
  end

  defp package do
    [
      description: "Use Swoosh to easily send emails in your Phoenix project.",
      maintainers: ["Steve Domin", "Po Chen"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/phoenix_swoosh/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        {:"README.md", [title: "Overview"]},
        "CHANGELOG.md",
        "CONTRIBUTING.md",
        "LICENSE.md": [title: "License"]
      ],
      main: "readme",
      canonical: "http://hexdocs.pm/phoenix_swoosh",
      source_url: @source_url,
      source_ref: "v#{@version}",
      api_reference: false,
      formatters: ["html"]
    ]
  end
end
