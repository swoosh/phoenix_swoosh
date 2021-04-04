# Phoenix.Swoosh

[![Elixir CI](https://github.com/swoosh/phoenix_swoosh/actions/workflows/elixir.yml/badge.svg)](https://github.com/swoosh/phoenix_swoosh/actions/workflows/elixir.yml)
[![Module Version](https://img.shields.io/hexpm/v/phoenix_swoosh.svg)](https://hex.pm/packages/phoenix_swoosh)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/phoenix_swoosh/)
[![Total Download](https://img.shields.io/hexpm/dt/phoenix_swoosh.svg)](https://hex.pm/packages/phoenix_swoosh)
[![License](https://img.shields.io/hexpm/l/phoenix_swoosh.svg)](https://github.com/swoosh/phoenix_swoosh/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/swoosh/phoenix_swoosh.svg)](https://github.com/swoosh/phoenix_swoosh/commits/master)

Use Swoosh to easily send emails in your Phoenix project.

This module provides the ability to set the HTML and/or text body of an email by rendering templates.

## Installation

Add `:phoenix_swoosh` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_swoosh, "~> 0.3"}
  ]
end
```

## Usage

Setting up the templates:

```elixir
# web/templates/layout/email.html.eex
<html>
  <head>
    <title><%= @email.subject %></title>
  </head>
  <body>
    <%= @inner_content %>
  </body>
</html>

# web/templates/email/welcome.html.eex
<div>
  <h1>Welcome to Sample, <%= @username %>!</h1>
</div>
```

Passing values to templates:

```elixir
# web/emails/user_email.ex
defmodule Sample.UserEmail do
  use Phoenix.Swoosh, view: Sample.EmailView, layout: {Sample.LayoutView, :email}

  def welcome(user) do
    new()
    |> from("tony@stark.com")
    |> to(user.email)
    |> subject("Hello, Avengers!")
    |> render_body("welcome.html", %{username: user.email})
  end
end
```

## Copyright and License

Copyright (c) 2016 Swoosh contributors

Released under the MIT License, which can be found in [LICENSE.md](./LICENSE.md).
