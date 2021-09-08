defmodule Bookpile.BooksTest do
  use Bookpile.DataCase

  alias Bookpile.Books

  describe "books" do
    alias Bookpile.Books.Book

    import Bookpile.BooksFixtures

    @invalid_attrs %{
      authors: nil,
      description: nil,
      image: nil,
      isbn10: nil,
      isbn13: nil,
      subtitle: nil,
      title: nil
    }

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Books.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Books.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{
        authors: [],
        description: "some description",
        image: "some image",
        isbn10: "some isbn10",
        isbn13: "some isbn13",
        subtitle: "some subtitle",
        title: "some title"
      }

      assert {:ok, %Book{} = book} = Books.create_book(valid_attrs)
      assert book.authors == []
      assert book.description == "some description"
      assert book.image == "some image"
      assert book.isbn10 == "some isbn10"
      assert book.isbn13 == "some isbn13"
      assert book.subtitle == "some subtitle"
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()

      update_attrs = %{
        authors: [],
        description: "some updated description",
        image: "some updated image",
        isbn10: "some updated isbn10",
        isbn13: "some updated isbn13",
        subtitle: "some updated subtitle",
        title: "some updated title"
      }

      assert {:ok, %Book{} = book} = Books.update_book(book, update_attrs)
      assert book.authors == []
      assert book.description == "some updated description"
      assert book.image == "some updated image"
      assert book.isbn10 == "some updated isbn10"
      assert book.isbn13 == "some updated isbn13"
      assert book.subtitle == "some updated subtitle"
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_book(book, @invalid_attrs)
      assert book == Books.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Books.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Books.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Books.change_book(book)
    end

    test "get_book_by_isbn/2 imports a book if not found" do
      book = Books.get_book_by_isbn("1529355273", Bookpile.HttpMock)

      assert book.title == "The 99% Invisible City"
      assert book.subtitle == "A Field Guide to the Wonders of the Modern Metropolis"
      assert book.authors == ["Roman Mars", "Kurt Kohlstedt", "99% Invisible"]

      assert book.description ==
               "99% Invisible' is a big-ideas podcast about small-seeming things, revealing stories baked into the buildings we inhabit, the streets we drive, and the sidewalks we traverse. The show celebrates design and architecture in all of its functional glory and accidental absurdity, with intriguing tales of both designers and the people impacted by their designs.00Now, in 'The 99% Invisible City: A Field Guide to Hidden World of Everyday Design', host Roman Mars and coauthor Kurt Kohlstedt zoom in on the various elements that make our cities work, exploring the origins and other fascinating stories behind everything from power grids and fire escapes to drinking fountains and street signs. With deeply researched entries and beautiful line drawings throughout, The 99% Invisible City will captivate devoted fans of the show and anyone curious about design, urban environments, and the unsung marvels of the world around them."

      assert book.isbn10 == "1529355273"
      assert book.isbn13 == "9781529355277"

      assert book.image ==
               "http://books.google.com/books/content?id=wGRNzQEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"

      assert book.media_type == "BOOK"
      assert book.page_count == 288
      assert book.published_date == "2020-10-06"
    end

    test "get_book_by_isbn/2 returns an existing book" do
      book = book_fixture(%{isbn10: "1234567890", title: "Existing Book"})
      found_book = Books.get_book_by_isbn("1234567890", Bookpile.HttpMock)

      assert book.id == book.id
      assert found_book.title == "Existing Book"
    end
  end
end
