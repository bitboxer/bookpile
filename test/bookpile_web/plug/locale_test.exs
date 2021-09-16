defmodule BookpileWeb.Plug.LocaleTest do
  use BookpileWeb.ConnCase

  test "setting the locale from the param", %{conn: conn} do
    conn = conn |> get("/", %{"locale" => "de"})
    assert Gettext.get_locale(BookpileWeb.Gettext) == "de"
    assert get_session(conn, :locale) == "de"
  end

  test "only allow correct locales and ignore wrong ones", %{conn: conn} do
    conn = conn |> get("/", %{"locale" => "de/"})
    assert Gettext.get_locale(BookpileWeb.Gettext) == "en"
    assert get_session(conn, :locale) == nil
  end

  test "setting the locale from the value stored in the session", %{conn: conn} do
    conn =
      conn
      |> get("/", %{"locale" => "de"})
      |> recycle()
      |> get("/")

    assert Gettext.get_locale(BookpileWeb.Gettext) == "de"
    assert get_session(conn, :locale) == "de"
  end

  test "return de if browser has de before en", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept-language", "it,cn,hu-de,de-DE,en")
      |> get("/")

    assert Gettext.get_locale(BookpileWeb.Gettext) == "de"
    assert get_session(conn, :locale) == "de"
  end
end
