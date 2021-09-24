# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 - 2021-09-25

### Added

The setup within a `Phoenix` is now referred to as the
[classic setup](https://github.com/swoosh/phoenix_swoosh#1-classic-setup).

1.0 adds the ability for the lib to be used outside `Phoenix` apps.

A new setup that doesn't involve a sparate view module is added and is called the standalone setup.
Both setups can work outsite `Phoenix` apps thanks to the recently extracted `Phoenix.View`.

#### Standalone setup

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

Layout can be setup the same way as
[classic setup](https://github.com/swoosh/phoenix_swoosh#1-classic-setup).

---

[Changelog prior to 1.0 can be found on 0.3.x branch](https://github.com/swoosh/phoenix_swoosh/blob/0.3.x/CHANGELOG.md)
