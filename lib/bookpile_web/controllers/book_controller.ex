defmodule BookpileWeb.BookController do
  use BookpileWeb, :controller

  alias Bookpile.Books
  alias Bookpile.Books.Search

  def show(conn, %{"isbn" => isbn}) do
    book = Books.get_book_by_isbn(isbn)

    if book do
      render(conn, "show.html", book: book)
    else
      conn
      |> put_flash(:error, "Sorry, book could not find the book.")
      |> redirect(to: "/")
    end
  end
end
