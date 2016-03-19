defmodule Phoenix.SwooshTest do
  use ExUnit.Case, async: true

  alias Swoosh.Email
  import Swoosh.Email
  import Phoenix.Swoosh

  defmodule EmailView do
    use Phoenix.View, root: "test/fixtures/templates", namespace: Swoosh.EmailView
  end

  defmodule LayoutView do
    use Phoenix.View, root: "test/fixtures/templates", namespace: Swoosh.LayoutView
  end

  defmodule TestEmail do
    use Phoenix.Swoosh, view: EmailView

    def welcome_html(), do: email() |> render_body("welcome.html", %{})
    def welcome_text(), do: email() |> render_body("welcome.text", %{})

    def welcome_html_assigns(), do: email() |> render_body("welcome_assigns.html", %{name: "Tony"})
    def welcome_text_assigns(), do: email() |> render_body("welcome_assigns.text", %{name: "Tony"})

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
    assert %Email{text_body: "Welcome, Avengers!\n"} =
           render_body(email, "welcome.text", %{})
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
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n",
                  text_body: "Welcome, Avengers!\n"} =
           render_body(email, :welcome, %{})
  end

  test "render both html and text body with layout", %{email: email} do
    email = email |> put_layout({LayoutView, :email})
    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n",
                  text_body: "TEXT: Welcome, Avengers!\n\n"} =
           render_body(email, :welcome, %{})
  end

  test "render both html and text body with assigns", %{email: email} do
    assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n",
                  text_body: "Welcome, Tony!\n"} =
           render_body(email, :welcome_assigns, %{name: "Tony"})
  end

  test "render both html and text body with layout and assigns", %{email: email} do
    email = email |> put_layout({LayoutView, :email})
    assert %Email{html_body: "<html><h1>Welcome, Tony!</h1>\n</html>\n",
                  text_body: "TEXT: Welcome, Tony!\n\n"} =
           render_body(email, :welcome_assigns, %{name: "Tony"})
  end

  test "macro: render html body" do
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n"} =
           TestEmail.welcome_html()
  end

  test "macro: render html body with layout" do
    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n"} =
           TestEmail.welcome_html_layout()
  end

  test "macro: render text body" do
    assert %Email{text_body: "Welcome, Avengers!\n"} =
           TestEmail.welcome_text()
  end

  test "macro: render text body with layout" do
    assert %Email{text_body: "TEXT: Welcome, Avengers!\n\n"} =
           TestEmail.welcome_text_layout()
  end

  test "macro: render html body with assigns" do
    assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n"} =
           TestEmail.welcome_html_assigns()
  end

  test "macro: render text body with assigns" do
    assert %Email{text_body: "Welcome, Tony!\n"} =
           TestEmail.welcome_text_assigns()
  end

  test "macro: render html body with layout and assigns" do
    assert %Email{html_body: "<html><h1>Welcome, Tony!</h1>\n</html>\n"} =
           TestEmail.welcome_html_layout_assigns()
  end

  test "macro: render text body with layout and assigns" do
    assert %Email{text_body: "TEXT: Welcome, Tony!\n\n"} =
           TestEmail.welcome_text_layout_assigns()
  end

  test "macro: render both html and text body" do
    assert %Email{html_body: "<h1>Welcome, Avengers!</h1>\n",
                  text_body: "Welcome, Avengers!\n"} =
           TestEmail.welcome()
  end

  test "macro: render both html and text body with layout" do
    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n",
                  text_body: "TEXT: Welcome, Avengers!\n\n"} =
           TestEmail.welcome_layout()
  end

  test "macro: render both html and text body with assigns" do
    assert %Email{html_body: "<h1>Welcome, Tony!</h1>\n",
                  text_body: "Welcome, Tony!\n"} =
           TestEmail.welcome_assigns()
  end

  test "macro: render both html and text body with layout and assigns" do
    assert %Email{html_body: "<html><h1>Welcome, Tony!</h1>\n</html>\n",
                  text_body: "TEXT: Welcome, Tony!\n\n"} =
           TestEmail.welcome_layout_assigns()
  end

  test "macro: use layout when provided via `use` macro " do
    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n",
                  text_body: "TEXT: Welcome, Avengers!\n\n"} =
           TestEmailLayout.welcome()
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

    assert %Email{html_body: "<html><h1>Welcome, Avengers!</h1>\n</html>\n"} =
           email
  end

  test "should raise if no view is set" do
    assert_raise ArgumentError, fn ->
      defmodule ErrorEmail do
        use Phoenix.Swoosh
      end
    end
  end
end
