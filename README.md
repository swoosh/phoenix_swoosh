# Phoenix.Swoosh

[![Build Status](https://travis-ci.org/swoosh/phoenix_swoosh.svg?branch=master)](https://travis-ci.org/swoosh/phoenix_swoosh)
[![Inline docs](http://inch-ci.org/github/swoosh/phoenix_swoosh.svg?branch=master&style=flat)](http://inch-ci.org/github/swoosh/phoenix_swoosh)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/swoosh/phoenix_swoosh.svg)](https://beta.hexfaktor.org/github/swoosh/phoenix_swoosh)

Use Swoosh to easily send emails in your Phoenix project.

This module provides the ability to set the HTML and/or text body of an email by rendering templates.

See the [docs](http://hexdocs.pm/phoenix_swoosh) for more information.

## Installation

  1. Add phoenix_swoosh to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:phoenix_swoosh, "~> 0.2"}]
    end
    ```

  2. Ensure phoenix_swoosh is started before your application:

    ```elixir
    def application do
      [applications: [:phoenix_swoosh]]
    end
    ```

## Documentation

Documentation is written into the library, you will find it in the source code, accessible from `iex` and of course, it
all gets published to [hexdocs](http://hexdocs.pm/phoenix_swoosh).

## Contributing

### Running tests

Clone the repo and fetch its dependencies:

```
$ git clone https://github.com/swoosh/phoenix_swoosh.git
$ cd phoenix_swoosh
$ mix deps.get
$ mix test
```

### Building docs

```
$ MIX_ENV=docs mix docs
```

## LICENSE

See [LICENSE](https://github.com/swoosh/phoenix_swoosh/blob/master/LICENSE.txt)
