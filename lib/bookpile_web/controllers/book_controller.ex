defmodule BookpileWeb.BookController do
  use BookpileWeb, :controller

  alias Bookpile.Books
  alias Bookpile.BookSources

  plug :put_layout, html: {BookpileWeb.Layouts, :book}

  def show(conn, %{"isbn" => raw_isbn}) do
    isbn = raw_isbn |> String.replace(~r/[\s-]/, "") |> String.trim()
    book = Books.get_book_by_isbn(isbn)

    if book do
      display_isbn = book.isbn13 || book.isbn10 || isbn
      render(conn, "show.html",
        book: book,
        isbn: display_isbn,
        regions_json: BookSources.regions_json()
      )
    else
      conn
      |> put_flash(:error, gettext("Sorry, could not find the book."))
      |> redirect(to: ~p"/")
    end
  end
end
