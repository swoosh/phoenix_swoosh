defmodule PhoenixSwoosh.Mixfile do
  use Mix.Project

  @source_url "https://github.com/swoosh/phoenix_swoosh"
  @version "0.3.3"

  def project do
    [
      app: :phoenix_swoosh,
      version: @version,
      elixir: "~> 1.8",
      name: "Phoenix.Swoosh",
      compilers: compilers(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      preferred_cli_env: [docs: :docs]
    ]
  end

  defp compilers(:test), do: [:phoenix] ++ Mix.compilers()
  defp compilers(_), do: Mix.compilers()

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:swoosh, "~> 1.0"},
      {:phoenix, "~> 1.4"},
      {:phoenix_html, "~> 2.14"},
      {:hackney, "~> 1.9"},
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :docs, runtime: false}
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
        "CHANGELOG.md",
        "CONTRIBUTING.md",
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
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
