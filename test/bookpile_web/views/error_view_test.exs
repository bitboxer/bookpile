defmodule BookpileWeb.ErrorHTMLTest do
  use BookpileWeb.ConnCase, async: true

  test "renders 404.html" do
    assert BookpileWeb.ErrorHTML.render("404.html", %{}) == "Not Found"
  end

  test "renders 500.html" do
    assert BookpileWeb.ErrorHTML.render("500.html", %{}) == "Internal Server Error"
  end
end
