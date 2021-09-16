defmodule BookpileWeb.BookController do
  use BookpileWeb, :controller

  alias Bookpile.Books

  def show(conn, %{"isbn" => isbn} = params) do
    book = Books.get_book_by_isbn(isbn)
    country = params["country"] || "de"

    if book do
      render(conn, "show.html", book: book, country: country)
    else
      conn
      |> put_flash(:error, gettext("Sorry, book could not find the book."))
      |> redirect(to: "/")
    end
  end
end
