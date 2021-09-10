defmodule Bookpile.Books.GoogleBookApiTest do
  use Bookpile.DataCase

  alias Bookpile.Books.GoogleBookApi

  describe "find_by_isbn/2" do
    test "finds a book" do
      assert GoogleBookApi.find_by_isbn("1529355273", Bookpile.HttpMock) ==
               {:ok,
                %{
                  title: "The 99% Invisible City",
                  subtitle: "A Field Guide to the Wonders of the Modern Metropolis",
                  authors: ["Roman Mars", "Kurt Kohlstedt", "99% Invisible"],
                  description:
                    "99% Invisible' is a big-ideas podcast about small-seeming things, revealing stories baked into the buildings we inhabit, the streets we drive, and the sidewalks we traverse. The show celebrates design and architecture in all of its functional glory and accidental absurdity, with intriguing tales of both designers and the people impacted by their designs.00Now, in 'The 99% Invisible City: A Field Guide to Hidden World of Everyday Design', host Roman Mars and coauthor Kurt Kohlstedt zoom in on the various elements that make our cities work, exploring the origins and other fascinating stories behind everything from power grids and fire escapes to drinking fountains and street signs. With deeply researched entries and beautiful line drawings throughout, The 99% Invisible City will captivate devoted fans of the show and anyone curious about design, urban environments, and the unsung marvels of the world around them.",
                  isbn10: "1529355273",
                  isbn13: "9781529355277",
                  image:
                    "http://books.google.com/books/content?id=wGRNzQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
                  media_type: "BOOK",
                  page_count: 288,
                  published_date: "2020-10-06"
                }}
    end

    test "returns an error if the book is not found" do
      assert GoogleBookApi.find_by_isbn("CANNOTBEFOUND", Bookpile.HttpMock) ==
               {:error, "Book not found"}
    end
  end
end
