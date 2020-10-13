defmodule PhoenixSwoosh.Mixfile do
  use Mix.Project

  @version "0.3.2"

  def project do
    [
      app: :phoenix_swoosh,
      version: @version,
      elixir: "~> 1.8",
      compilers: compilers(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "Phoenix.Swoosh",
      docs: [
        source_ref: "v#{@version}",
        main: "Phoenix.Swoosh",
        canonical: "http://hexdocs.pm/phoenix_swoosh",
        source_url: "https://github.com/swoosh/phoenix_swoosh"
      ]
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
      {:ex_doc, "~> 0.22", only: :docs}
    ]
  end

  defp description do
    """
    Use Swoosh to easily send emails in your Phoenix project.
    """
  end

  defp package do
    [
      maintainers: ["Steve Domin", "Po Chen"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/swoosh/phoenix_swoosh"}
    ]
  end
end
