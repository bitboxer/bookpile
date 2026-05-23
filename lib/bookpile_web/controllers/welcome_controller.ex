defmodule BookpileWeb.WelcomeController do
  use BookpileWeb, :controller

  alias Bookpile.BookSources
  alias Bookpile.GeoIP

  @demo_isbn "9781529340594"

  def index(conn, _params) do
    {country, city} = detect_location(conn)
    render(conn, "index.html", country: country, city: city, stats: BookSources.stats())
  end

  defp detect_location(conn) do
    ip =
      case get_req_header(conn, "x-forwarded-for") do
        [forwarded | _] -> forwarded |> String.split(",") |> List.first() |> String.trim()
        [] -> conn.remote_ip |> :inet.ntoa() |> to_string()
      end

    {raw_country, raw_city} = GeoIP.detect(ip)
    BookSources.best_match(raw_country, raw_city)
  end

  def search(conn, params) do
    raw = params["isbn"] || ""
    isbn = raw |> String.replace(~r/[\s-]/, "") |> String.trim()
    target = if isbn == "", do: @demo_isbn, else: isbn
    redirect(conn, to: ~p"/b/#{target}")
  end
end
