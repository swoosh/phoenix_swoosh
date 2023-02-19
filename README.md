# Phoenix.Swoosh

[![Elixir CI](https://github.com/swoosh/phoenix_swoosh/actions/workflows/elixir.yml/badge.svg)](https://github.com/swoosh/phoenix_swoosh/actions/workflows/elixir.yml)
[![Module Version](https://img.shields.io/hexpm/v/phoenix_swoosh.svg)](https://hex.pm/packages/phoenix_swoosh)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/phoenix_swoosh/)
[![Total Download](https://img.shields.io/hexpm/dt/phoenix_swoosh.svg)](https://hex.pm/packages/phoenix_swoosh)
[![License](https://img.shields.io/hexpm/l/phoenix_swoosh.svg)](https://github.com/swoosh/phoenix_swoosh/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/swoosh/phoenix_swoosh.svg)](https://github.com/swoosh/phoenix_swoosh/commits/master)

`Phoenix.View` + `Swoosh`. ([Discuss about the future post-Phoenix-1.7 here](https://github.com/swoosh/phoenix_swoosh/issues/287))

This module provides the ability to set the HTML and/or text body of an email by rendering templates.

## Installation

Add `:phoenix_swoosh` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phoenix_swoosh, "~> 1.0"},

    # without phoenix_html, phoenix_swoosh only works with plain text templates
    # if you want to use HTML templates
    # {:phoenix_html, "~> 3.0"},
  ]
end
```

You probably also want to install [`finch`](https://hex.pm/packages/finch),
[`hackney`](https://hex.pm/packages/hackney) or an HTTP client of your own choice,
if you are using a provider that `Swoosh` talks to via their HTTP API.

Or [`:gen_smtp`](https://hex.pm/packages/gen_smtp) if you are working with a provider
that only works through SMTP.

See `Swoosh` for more details.

## Usage

### 1. Classic setup

Setting up the templates:

```eex
# path_to/templates/user_notifier/welcome.html.eex
<div>
  <h1>Welcome to Sample, <%= @name %>!</h1>
</div>
```

```elixir
# path_to/views/user_notifier_view.ex
defmodule Sample.UserNotifierView do
  use Phoenix.View, root: "path_to/templates"
end
```

Passing values to templates:

```elixir
# path_to/notifiers/user_notifier.ex
defmodule Sample.UserNotifier do
  use Phoenix.Swoosh, view: Sample.UserNotifierView

  def welcome(user) do
    new()
    |> from("tony@stark.com")
    |> to(user.email)
    |> subject("Hello, Avengers!")
    |> render_body("welcome.html", %{name: name})
  end
end
```

Maybe with a layout:

```eex
# path_to/templates/layout/email.html.eex
<html>
  <head>
    <title><%= @email.subject %></title>
  </head>
  <body>
    <%= @inner_content %>
  </body>
</html>
```

```elixir
defmodule Sample.LayoutView do
  use Phoenix.View, root: "path_to/templates"
end
```

```elixir
# path_to/notifiers/user_notifier.ex
defmodule Sample.UserNotifier do
  use Phoenix.Swoosh,
    view: Sample.NotifierView,
    layout: {Sample.LayoutView, :email}

  # ... same welcome ...
end
```

Layout can also be added/changed dynamically with `put_new_layout/2` and `put_layout/2`

### 2. Standalone setup

```eex
# path_to/templates/user_notifier/welcome.html.eex
<div>
  <h1>Welcome to Sample, <%= @name %>!</h1>
</div>
```

```elixir
# path_to/notifiers/user_notifier.ex
defmodule Sample.UserNotifier do
  use Phoenix.Swoosh,
    template_root: "path_to/templates",
    template_path: "user_notifier"

  # ... same welcome ...
end
```

In this setup, the notifier module itself serves as the view module

`template_root`, `template_path` and `template_namespace`
will be passed to `Phoenix.View` as `root`, `path` and `namespace`.

Layout can be setup the same way as classic setup.

## Customization

When using either the classic or standalone setup described above, the
extensions of the templates used can be customized. For example, let's say
MJML is the desired markup language to use for HTML emails, and there's a
template such as:

```eex
# path_to/templates/user_notifier/welcome.mjml.eex

<mjml>
  <mj-body>
    <mj-text>Welcome to Sample, <%= @name %>!</mj-text>
  </mj-body>
</mjml>
```

Phoenix.Swoosh can be configured to use the "mjml" extension when rendering the
HTML body of the email:

```elixir
# path_to/notifiers/user_notifier.ex
defmodule Sample.UserNotifier do
  use Phoenix.Swoosh,
    formats: %{"mjml" => :html_body, "text" => :text_body}

  # ... same welcome as above ...
end
```

This requires that Phoenix knows how to handle templates using the "mjml"
format. This can be done by creating a module that exports
`encode_to_iodata!/1`:

```elixir
defmodule Sample.Mjml do
  def encode_to_iodata!(mjml) do
    with {:ok, html} <- Mjml.to_html(mjml) do
      html
    end
  end
end
```

And then configuring Phoenix to use it:

```elixir
config :phoenix, format_encoders: [mjml: Sample.Mjml]
```

The above example is using [`mjml`](https://hex.pm/packages/mjml), which would
need to be installed as well.

## Copyright and License

Copyright (c) 2021 Swoosh contributors

Released under the MIT License, which can be found in [LICENSE.md](./LICENSE.md).
