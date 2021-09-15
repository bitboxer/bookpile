defmodule Bookpile.Books.GoodreadsTest do
  use Bookpile.DataCase

  alias Bookpile.Books.Goodreads

  describe "find_by_isbn/2" do
    test "finds a book" do
      assert Goodreads.find_by_isbn("3847900781", Bookpile.HttpMock) ==
               {:ok,
                %{
                  title: "Herzschlag ins Gesicht",
                  authors: ["Bente Theuvsen"],
                  description:
                    "In ihren Cartoons bringt Bente Theuvsen Alltagssituationen aus dem Elterndasein witzig und pointiert aufs Blatt. Ob ewige Klamottendiskussionen, das Ausplaudern von allerhand Peinlichkeiten oder ungewünschter Wahrheiten - irgendwie muss man die Kleinen doch immer wieder ins Herz schließen. Vor allem, wenn sie Geralt von Riva sogar von Luke Skywalker unterscheiden können.",
                  image:
                    "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1616921027l/57532688._SX318_.jpg",
                  isbn10: "3847900781",
                  page_count: 96
                }}
    end

    test "returns an error if the book is not found" do
      assert Goodreads.find_by_isbn("notfound", Bookpile.HttpMock) ==
               {:error, "Book not found"}
    end
  end
end
