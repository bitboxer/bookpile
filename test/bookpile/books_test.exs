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
  end
end
