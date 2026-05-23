defmodule BookpileWeb.WelcomeController do
  use BookpileWeb, :controller

  @demo_isbn "9781529340594"

  def index(conn, _params) do
    render(conn, "index.html", [])
  end

  def search(conn, params) do
    raw = params["isbn"] || ""
    isbn = raw |> String.replace(~r/[\s-]/, "") |> String.trim()
    target = if isbn == "", do: @demo_isbn, else: isbn
    redirect(conn, to: ~p"/b/#{target}")
  end
end
