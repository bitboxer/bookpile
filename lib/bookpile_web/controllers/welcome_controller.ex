defmodule BookpileWeb.WelcomeController do
  use BookpileWeb, :controller

  alias Bookpile.Books

  def index(conn, _params) do
    changeset = Books.search_changeset(%{isbn: nil})
    render(conn, "index.html", changeset: changeset)
  end

  def search(conn, %{"search" => search_params}) do
    search = Books.search_changeset(search_params)

    if search.valid? do
      redirect(conn, to: "/books/#{search_params["isbn"]}")
    else
      changeset = Books.search_changeset(%{isbn: "isbn"})
      render(conn, "index.html", changeset: changeset)
    end
  end
end
