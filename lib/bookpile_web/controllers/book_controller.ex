defmodule BookpileWeb.BookController do
  use BookpileWeb, :controller

  alias Bookpile.Books
  alias Bookpile.BookSources
  alias Bookpile.GeoIP

  plug :put_layout, html: {BookpileWeb.Layouts, :book}

  def show(conn, %{"isbn" => raw_isbn, "refresh" => "true"}) do
    isbn = raw_isbn |> String.replace(~r/[\s-]/, "") |> String.trim()
    Books.refresh_book(isbn)
    redirect(conn, to: ~p"/b/#{isbn}")
  end

  def show(conn, %{"isbn" => raw_isbn} = params) do
    isbn = raw_isbn |> String.replace(~r/[\s-]/, "") |> String.trim()
    book = Books.get_book_by_isbn(isbn)

    if book do
      display_isbn = book.isbn13 || book.isbn10 || isbn
      {country, city} = resolve_location(conn, params)
      listings = BookSources.listings_for(country, city)

      render(conn, "show.html",
        book: book,
        isbn: display_isbn,
        regions_json: BookSources.regions_json(),
        country: country,
        city: city,
        local_shops: listings["local_shops"] || [],
        national_shops: listings["national_shops"] || [],
        libraries: listings["libraries"] || [],
        trackers: listings["trackers"] || []
      )
    else
      conn
      |> put_flash(:error, gettext("Sorry, could not find the book."))
      |> redirect(to: ~p"/")
    end
  end

  defp resolve_location(_conn, %{"country" => country, "city" => city}) do
    BookSources.best_match(country, city)
  end

  defp resolve_location(conn, _params) do
    ip = client_ip(conn)
    {raw_country, raw_city} = GeoIP.detect(ip)
    BookSources.best_match(raw_country, raw_city)
  end

  defp client_ip(conn) do
    case get_req_header(conn, "x-forwarded-for") do
      [forwarded | _] -> forwarded |> String.split(",") |> List.first() |> String.trim()
      [] -> conn.remote_ip |> :inet.ntoa() |> to_string()
    end
  end
end
