defmodule Phoenix.SwooshTest do
  use ExUnit.Case, async: true

  alias Swoosh.Email
  import Swoosh.Email
  import Phoenix.Swoosh

  defmodule EmailView do
    use Phoenix.View, root: "test/fixtures/templates", namespace: Phoenix.SwooshTest
  end

  defmodule LayoutView do
    use Phoenix.View, root: "test/fixtures/templates", namespace: Phoenix.SwooshTest
  end

  defmodule TestEmail do
    use Phoenix.Swoosh, view: EmailView

    def welcome_html(), do: email() |> render_body("welcome.html", %{})
    def welcome_text(), do: email() |> render_body("welcome.text", %{})

    def welcome_custom() do
      email()
      |> put_formats(%{"html" => "custom"})
      |> render_body("welcome.custom", %{})
    end

    def welcome_html_assigns(),
      do: email() |> render_body("welcome_assigns.html", %{name: "Tony"})

    def welcome_text_assigns(),
      do: email() |> render_body("welcome_assigns.text", %{name: "Tony"})

    def welcome_custom_assigns() do
      email()
      |> put_formats(%{"html" => "custom"})
      |> render_body("welcome_assigns.custom", %{name: "Tony"})
    end

    def welcome_html_without_assigns(), do: email() |> render_body("welcome.html")
    def welcome_text_without_assigns(), do: email() |> render_body("welcome.text")

    def welcome_custom_without_assigns() do
      email()
      |> put_formats(%{"html" => "custom"})
      |> render_body("welcome.custom")
    end

    def welcome_html_layout() do
      email()
      |> put_layout({LayoutView, "email.html"})
      |> render_body("welcome.html", %{})
    end

    def welcome_text_layout() do
      email()
      |> put_layout({LayoutView, "email.text"})
      |> render_body("welcome.text", %{})
    end

    def welcome_html_layout_without_assigns() do
      email()
      |> put_layout({LayoutView, "email.html"})
      |> render_body("welcome.html")
    end

    def welcome_text_layout_without_assigns() do
      email()
      |> put_layout({LayoutView, "email.text"})
      |> render_body("welcome.text")
    end

    def welcome_html_layout_assigns() do
      email()
      |> put_layout({LayoutView, "email.html"})
      |> render_body("welcome_assigns.html", %{name: "Tony"})
    end

    def welcome_text_layout_assigns() do
      email()
      |> put_layout({LayoutView, "email.text"})
      |> render_body("welcome_assigns.text", %{name: "Tony"})
    end

    def welcome(), do: email() |> render_body(:welcome, %{})

    def welcome_assigns(), do: email() |> render_body(:welcome_assigns, %{name: "Tony"})

    def welcome_layout() do
      email()
      |> put_layout({LayoutView, :email})
      |> render_body(:welcome, %{})
    end

    def welcome_layout_assigns() do
      email()
      |> put_layout({LayoutView, :email})
      |> render_body(:welcome_assigns, %{name: "Tony"})
    end

    def welcome_formats() do
      email()
      |> put_formats(%{"html" => "custom", "text" => "text"})
      |> render_body(:welcome, %{})
    end

    def welcome_formats_assigns() do
      email()
      |> put_formats(%{"html" => "custom", "text" => "text"})
      |> render_body(:welcome_assigns, %{name: "Tony"})
    end

    def welcome_formats_layout() do
      email()
      |> put_formats(%{"html" => "custom", "text" => "text"})
      |> put_layout({LayoutView, :email})
      |> render_body(:welcome, %{})
    end

    def welcome_formats_layout_assigns() do
      email()
      |> put_formats(%{"html" => "custom", "text" => "text"})
      |> put_layout({LayoutView, :email})
      |> render_body(:welcome_assigns, %{name: "Tony"})
    end

    def email() do
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
    end
  end

  defmodule TestEmailLayout do
    use Phoenix.Swoosh, view: EmailView, layout: {LayoutView, :email}

    def welcome() do
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
      |> render_body(:welcome, %{})
    end
  end

  defmodule TestEmailLayoutFormats do
    use Phoenix.Swoosh,
      formats: %{"html" => "custom", "text" => "text"},
      view: EmailView,
      layout: {LayoutView, :email}

    def welcome() do
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
      |> render_body(:welcome, %{})
    end
  end

  defmodule TestViewIncludedNotifier do
    use Phoenix.Swoosh,
      template_root: "test/fixtures/templates",
      template_namespace: Phoenix.SwooshTest

    import Swoosh.Email

    def welcome_assigns do
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
      |> render_body(:welcome_assigns, %{name: "Tony"})
    end

    def welcome_layout do
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
      |> put_layout({LayoutView, :email})
      |> render_body(:welcome_assigns, %{name: "Avengers"})
    end
  end

  defmodule TestViewIncludedNotifierFormats do
    use Phoenix.Swoosh,
      formats: %{"html" => "custom", "text" => "text"},
      template_root: "test/fixtures/templates",
      template_namespace: Phoenix.SwooshTest

    import Swoosh.Email

    def welcome_assigns do
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
      |> render_body(:welcome_assigns, %{name: "Tony"})
    end

    def welcome_layout do
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
      |> put_layout({LayoutView, :email})
      |> render_body(:welcome_assigns, %{name: "Avengers"})
    end
  end

  setup_all do
    email =
      %Email{}
      |> from("tony@stark.com")
      |> to("steve@rogers.com")
      |> subject("Welcome, Avengers!")
      |> put_view(EmailView)

    {:ok, email: email}
  end

  test "render html body", %{email: email} do
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n"} =
             render_body(email, "welcome.html", %{})
  end

  test "render html body with layout", %{email: email} do
    email = email |> put_layout({LayoutView, "email.html"})

    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n"} =
             render_body(email, "welcome.html", %{})
  end

  test "render text body", %{email: email} do
    assert %Email{text_body: "Welcome, Avengers!\n"} = render_body(email, "welcome.text", %{})
  end

  test "render text body with layout", %{email: email} do
    email = email |> put_layout({LayoutView, "email.text"})

    assert %Email{text_body: "TEXT: Welcome, Avengers!\n\n"} =
             render_body(email, "welcome.text", %{})
  end

  test "render html body with assigns", %{email: email} do
    assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n"} =
             render_body(email, "welcome_assigns.html", %{name: "Tony"})
  end

  test "render text body with assigns", %{email: email} do
    assert %Email{text_body: "Welcome, Tony!\n"} =
             render_body(email, "welcome_assigns.text", %{name: "Tony"})
  end

  test "render html body with layout and assigns", %{email: email} do
    email = email |> put_layout({LayoutView, "email.html"})

    assert %Email{html_body: "<html><h1>Welcome, Tony!</h1>\n</html>\n"} =
             render_body(email, "welcome_assigns.html", %{name: "Tony"})
  end

  test "render text body with layout and assigns", %{email: email} do
    email = email |> put_layout({LayoutView, "email.text"})

    assert %Email{text_body: "TEXT: Welcome, Tony!\n\n"} =
             render_body(email, "welcome_assigns.text", %{name: "Tony"})
  end

  test "render both html and text body", %{email: email} do
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n", text_body: "Welcome, Avengers!\n"} =
             render_body(email, :welcome, %{})
  end

  test "render both html and text body with layout", %{email: email} do
    email = email |> put_layout({LayoutView, :email})

    assert %Email{
             html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n",
             text_body: "TEXT: Welcome, Avengers!\n\n"
           } = render_body(email, :welcome, %{})
  end

  test "render both html and text body with assigns", %{email: email} do
    assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n", text_body: "Welcome, Tony!\n"} =
             render_body(email, :welcome_assigns, %{name: "Tony"})
  end

  test "render both html and text body with layout and assigns", %{email: email} do
    email = email |> put_layout({LayoutView, :email})

    assert %Email{
             html_body: "<html><h1>Welcome, Tony!</h1>\n</html>\n",
             text_body: "TEXT: Welcome, Tony!\n\n"
           } = render_body(email, :welcome_assigns, %{name: "Tony"})
  end

  test "macro: render html body" do
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n"} = TestEmail.welcome_html()
  end

  test "macro: render text body" do
    assert %Email{text_body: "Welcome, Avengers!\n"} = TestEmail.welcome_text()
  end

  test "macro: render html body with custom format" do
    assert %Email{html_body: "<element>Welcome, Avengers!</element>\n"} =
             TestEmail.welcome_custom()
  end

  test "macro: render html body with layout" do
    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n"} =
             TestEmail.welcome_html_layout()
  end

  test "macro: render text body with layout" do
    assert %Email{text_body: "TEXT: Welcome, Avengers!\n\n"} = TestEmail.welcome_text_layout()
  end

  test "macro: render html body with layout without assigns" do
    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n"} =
             TestEmail.welcome_html_layout_without_assigns()
  end

  test "macro: render text body with layout without assigns" do
    assert %Email{text_body: "TEXT: Welcome, Avengers!\n\n"} =
             TestEmail.welcome_text_layout_without_assigns()
  end

  test "macro: render html body without assigns" do
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n"} =
             TestEmail.welcome_html_without_assigns()
  end

  test "macro: render text body without assigns" do
    assert %Email{text_body: "Welcome, Avengers!\n"} = TestEmail.welcome_text_without_assigns()
  end

  test "macro: render html body with custom format and without assigns" do
    assert %Email{html_body: "<element>Welcome, Avengers!</element>\n"} =
             TestEmail.welcome_custom_without_assigns()
  end

  test "macro: render html body with assigns" do
    assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n"} = TestEmail.welcome_html_assigns()
  end

  test "macro: render text body with assigns" do
    assert %Email{text_body: "Welcome, Tony!\n"} = TestEmail.welcome_text_assigns()
  end

  test "macro: render html body with custom format and assigns" do
    assert %Email{html_body: "<element>Welcome, Tony!</element>\n"} =
             TestEmail.welcome_custom_assigns()
  end

  test "macro: render html body with layout and assigns" do
    assert %Email{html_body: "<html><h1>Welcome, Tony!</h1>\n</html>\n"} =
             TestEmail.welcome_html_layout_assigns()
  end

  test "macro: render text body with layout and assigns" do
    assert %Email{text_body: "TEXT: Welcome, Tony!\n\n"} = TestEmail.welcome_text_layout_assigns()
  end

  test "macro: render both html and text body" do
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n", text_body: "Welcome, Avengers!\n"} =
             TestEmail.welcome()
  end

  test "macro: render both html and text body with layout" do
    assert %Email{
             html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n",
             text_body: "TEXT: Welcome, Avengers!\n\n"
           } = TestEmail.welcome_layout()
  end

  test "macro: render both html and text body with assigns" do
    assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n", text_body: "Welcome, Tony!\n"} =
             TestEmail.welcome_assigns()
  end

  test "macro: render both html and text body with layout and assigns" do
    assert %Email{
             html_body: "<html><h1>Welcome, Tony!</h1>\n</html>\n",
             text_body: "TEXT: Welcome, Tony!\n\n"
           } = TestEmail.welcome_layout_assigns()
  end

  test "macro: render both html and text body with custom formats" do
    assert %Email{
             html_body: "<element>Welcome, Avengers!</element>\n",
             text_body: "Welcome, Avengers!\n"
           } = TestEmail.welcome_formats()
  end

  test "macro: render both html and text body with custom formats and assigns" do
    assert %Email{
             html_body: "<element>Welcome, Tony!</element>\n",
             text_body: "Welcome, Tony!\n"
           } = TestEmail.welcome_formats_assigns()
  end

  test "macro: render both html and text body with custom formats and layout" do
    assert %Email{
             html_body: "<layout><element>Welcome, Avengers!</element>\n</layout>\n",
             text_body: "TEXT: Welcome, Avengers!\n\n"
           } = TestEmail.welcome_formats_layout()
  end

  test "macro: render both html and text body with custom formats, layout, and assigns" do
    assert %Email{
             html_body: "<layout><element>Welcome, Tony!</element>\n</layout>\n",
             text_body: "TEXT: Welcome, Tony!\n\n"
           } = TestEmail.welcome_formats_layout_assigns()
  end

  test "macro: use layout when provided via `use` macro " do
    assert %Email{
             html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n",
             text_body: "TEXT: Welcome, Avengers!\n\n"
           } = TestEmailLayout.welcome()
  end

  test "macro: use layout for custom format when provided via `use` macro " do
    assert %Email{
             html_body: "<layout><element>Welcome, Avengers!</element>\n</layout>\n",
             text_body: "TEXT: Welcome, Avengers!\n\n"
           } = TestEmailLayoutFormats.welcome()
  end

  test "email is available in template", %{email: email} do
    assert %Email{html_body: "<div>Welcome from tony@stark.com</div>\n"} =
             render_body(email, "welcome_from.html", %{})
  end

  test "put_layout/2", %{email: email} do
    email =
      email
      |> put_layout({LayoutView, :wrong})
      |> put_layout(:email)
      |> render_body("welcome.html", %{})

    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n"} = email
  end

  describe "view included" do
    test "render both html and text body with assigns" do
      assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n", text_body: "Welcome, Tony!\n"} =
               TestViewIncludedNotifier.welcome_assigns()
    end

    test "render both html and text body with layout" do
      assert %Email{
               html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n",
               text_body: "TEXT: Welcome, Avengers!\n\n"
             } = TestViewIncludedNotifier.welcome_layout()
    end
  end

  describe "view included and formats defined" do
    test "render both html and text body with assigns" do
      assert %Email{
               html_body: "<element>Welcome, Tony!</element>\n",
               text_body: "Welcome, Tony!\n"
             } = TestViewIncludedNotifierFormats.welcome_assigns()
    end

    test "render both html and text body with layout" do
      assert %Email{
               html_body: "<layout><element>Welcome, Avengers!</element>\n</layout>\n",
               text_body: "TEXT: Welcome, Avengers!\n\n"
             } = TestViewIncludedNotifierFormats.welcome_layout()
    end
  end

  test "should raise if no view is set" do
    assert_raise ArgumentError, fn ->
      defmodule ErrorEmail do
        use Phoenix.Swoosh
      end
    end
  end

  test "body formats are set according to template file extension", %{email: email} do
    assert email |> render_body("format_html.html", %{}) |> Map.fetch!(:html_body) =~
             "This is an HTML template"

    assert email |> render_body("format_html.htm", %{}) |> Map.fetch!(:html_body) =~
             "This is an HTML template"

    assert email |> render_body("format_html.xml", %{}) |> Map.fetch!(:html_body) =~
             "This is an HTML template"

    assert email |> render_body("format_text.txt", %{}) |> Map.fetch!(:text_body) =~
             "This is a text template"

    assert email |> render_body("format_text.text", %{}) |> Map.fetch!(:text_body) =~
             "This is a text template"

    assert email |> render_body("format_text.unknown", %{}) |> Map.fetch!(:text_body) =~
             "This is a text template"

    assert email
           |> put_formats(%{"html" => "custom", "text" => "text"})
           |> render_body("format_html.custom", %{})
           |> Map.fetch!(:html_body) =~
             "This is an HTML template"
  end
end
