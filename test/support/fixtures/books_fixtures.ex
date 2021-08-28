defmodule Bookpile.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bookpile.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        authors: [],
        description: "some description",
        image: "some image",
        isbn10: "some isbn10",
        isbn13: "some isbn13",
        subtitle: "some subtitle",
        title: "some title"
      })
      |> Bookpile.Books.create_book()

    book
  end
end
