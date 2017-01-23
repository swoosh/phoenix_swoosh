defmodule Phoenix.Swoosh do
  @moduledoc """
  The main feature provided by this module is the ability to set the HTML and/or
  text body of an email by rendering templates.

  It has been designed to integrate with Phoenix view, template and layout system.

  ## Example

      # web/templates/layout/email.html.eex
      <html>
        <head>
          <title><%= @email.subject %></title>
        </head>
        <body>
          <%= render @view_module, @view_template, assigns %>
        </body>
      </html>

      # web/templates/email/welcome.html.eex
      <div>
        <h1>Welcome to Sample, <%= @username %>!</h1>
      </div>

      # web/emails/user_email.ex
      defmodule Sample.UserEmail do
        use Phoenix.Swoosh, view: Sample.EmailView, layout: {Sample.LayoutView, :email}

        def welcome(user) do
          %Email{}
          |> from("tony@stark.com")
          |> to(user.email)
          |> subject("Hello, Avengers!")
          |> render_body("welcome.html", %{username: user.email})
        end
      end
  """

  import Swoosh.Email

  defmacro __using__(opts) do
    unless view = Keyword.get(opts, :view) do
      raise ArgumentError, "no view was set, " <>
                           "you can set one with `use Phoenix.Swoosh, view: MyApp.EmailView`"
    end
    layout = Keyword.get(opts, :layout)
    quote bind_quoted: [view: view, layout: layout] do
      import Swoosh.Email
      import Phoenix.Swoosh, except: [render_body: 3]

      @view view
      @layout layout || false

      def render_body(email, template, assigns \\ %{}) do
        email
        |> put_new_layout(@layout)
        |> put_new_view(@view)
        |> Phoenix.Swoosh.render_body(template, assigns)
      end
    end
  end

  @doc """
  Renders the given `template` and `assigns` based on the `email`.

  Once the template is rendered the resulting string is stored on the email fields `html_body` and `text_body` depending
  on the format of the template.

  ## Arguments

    * `email` - the `Swoosh.Email` struct

    * `template` - may be an atom or a string. If an atom, like `:welcome`, it
      will render both the HTML and text template and stores them respectively on
      the email. If the template is a string it must contain the extension too,
      like `welcome.html`.

    * `assigns` - a dictionnary with the assigns to be used in the view. Those
      assigns are merged and have higher order precedence than the email assigns.
      (`email.assigns`)

  ## Example

      defmodule Sample.UserEmail do
        use Phoenix.Swoosh, view: Sample.EmailView

        def welcome(user) do
          %Email{}
          |> from("tony@stark.com")
          |> to(user.email)
          |> subject("Hello, Avengers!")
          |> render_body("welcome.html", %{username: user.email})
        end
      end

  The example above renders a template `welcome.html` from `Sample.EmailView` and
  stores the resulting string onto the html_body field of the email.
  (`email.html_body`)

  In many cases you may want to set both the html and text body of an email. To
  do so you can pass the template name as an atom (without the extension):

      def welcome(user) do
        %Email{}
        |> from("tony@stark.com")
        |> to(user.email)
        |> subject("Hello, Avengers!")
        |> render_body(:welcome, %{username: user.email})
      end

  ## Layouts

  Templates are often rendered inside layouts. If you wish to do so you will have
  to specify which layout you want to use when using the `Phoenix.Swoosh` module.

      defmodule Sample.UserEmail do
        use Phoenix.Swoosh, view: Sample.EmailView, layout: {Sample.LayoutView, :email}

        def welcome(user) do
          %Email{}
          |> from("tony@stark.com")
          |> to(user.email)
          |> subject("Hello, Avengers!")
          |> render_body("welcome.html", %{username: user.email})
        end
      end

  The example above will render the `welcome.html` template inside an
  `email.html` template specified in `Sample.LayoutView`. `put_layout/2` can be
  used to change the layout, similar to how `put_view/2` can be used to change
  the view.
  """
  def render_body(email, template, assigns) when is_atom(template) do
    email
    |> do_render_body(template_name(template, "html"), "html", assigns)
    |> do_render_body(template_name(template, "text"), "text", assigns)
  end

  def render_body(email, template, assigns) when is_binary(template) do
    case Path.extname(template) do
      "." <> format ->
        do_render_body(email, template, format, assigns)
      "" ->
        raise "cannot render template #{inspect template} without format. Use an atom if you " <>
              "want to set both the html and text body."
    end
  end

  defp do_render_body(email, template, format, assigns) do
    assigns = Enum.into(assigns, %{})
    email =
      email
      |> put_private(:phoenix_template, template)
      |> prepare_assigns(assigns, format)

    view = Map.get(email.private, :phoenix_view) ||
            raise "a view module was not specified, set one with put_view/2"

    content = Phoenix.View.render_to_string(view, template, Map.put(email.assigns, :email, email))
    Map.put(email, :"#{format}_body", content)
  end

  @doc """
  Stores the layout for rendering.

  The layout must be a tuple, specifying the layout view and the layout
  name, or false. In case a previous layout is set, `put_layout` also
  accepts the layout name to be given as a string or as an atom. If a
  string, it must contain the format. Passing an atom means the layout
  format will be found at rendering time, similar to the template in
  `render_body/3`. It can also be set to `false`. In this case, no
  layout would be used.

  ## Examples

      iex> layout(email)
      false

      iex> email = put_layout email, {LayoutView, "email.html"}
      iex> layout(email)
      {LayoutView, "email.html"}

      iex> email = put_layout email, "email.html"
      iex> layout(email)
      {LayoutView, "email.html"}

      iex> email = put_layout email, :email
      iex> layout(email)
      {AppView, :email}
  """
  def put_layout(email, layout) do
    do_put_layout(email, layout)
  end

  defp do_put_layout(email, false) do
    put_private(email, :phoenix_layout, false)
  end

  defp do_put_layout(email, {mod, layout}) when is_atom(mod) do
    put_private(email, :phoenix_layout, {mod, layout})
  end

  defp do_put_layout(email, layout) when is_binary(layout) or is_atom(layout) do
    update_in email.private, fn private ->
      case Map.get(private, :phoenix_layout, false) do
        {mod, _} -> Map.put(private, :phoenix_layout, {mod, layout})
        false    -> raise "cannot use put_layout/2 with atom/binary when layout is false, use a tuple instead"
      end
    end
  end

  @doc """
  Stores the layout for rendering if one was not stored yet.
  """
  def put_new_layout(email, layout)
      when (is_tuple(layout) and tuple_size(layout) == 2) or layout == false do
    update_in email.private, &Map.put_new(&1, :phoenix_layout, layout)
  end

  @doc """
  Retrieves the current layout of an email.
  """
  def layout(email), do: email.private |> Map.get(:phoenix_layout, false)

  @doc """
  Stores the view for rendering.
  """
  def put_view(email, module) do
    put_private(email, :phoenix_view, module)
  end

  @doc """
  Stores the view for rendering if one was not stored yet.
  """
  def put_new_view(email, module) do
    update_in email.private, &Map.put_new(&1, :phoenix_view, module)
  end

  defp prepare_assigns(email, assigns, format) do
    layout =
      case layout(email, assigns, format) do
        {mod, layout} -> {mod, template_name(layout, format)}
        false -> false
      end

    update_in email.assigns,
              & &1 |> Map.merge(assigns) |> Map.put(:layout, layout)
  end

  defp layout(email, assigns, format) do
    if format in ["html", "text"] do
      case Map.fetch(assigns, :layout) do
        {:ok, layout} -> layout
        :error -> layout(email)
      end
    else
      false
    end
  end

  defp template_name(name, format) when is_atom(name), do:
    Atom.to_string(name) <> "." <> format
  defp template_name(name, _format) when is_binary(name), do:
    name
end
