defmodule Bookpile.Books.InventaireTest do
  use ExUnit.Case, async: true

  alias Bookpile.Books.Inventaire

  test "find_by_isbn/2 returns a book when found" do
    assert {:ok, book} = Inventaire.find_by_isbn("9780593820254", Bookpile.HttpMock)

    assert book.title == "Dungeon Crawler Carl"
    assert book.image == "https://inventaire.io/img/entities/7fedca42338b7f87f0da1bad109d19fae86f735e"
    assert book.isbn13 == "978-0-593-82025-4"
    assert book.isbn10 == "0-593-82025-8"
    assert book.published_date == "2020"
  end

  test "find_by_isbn/2 returns an error when not found" do
    assert {:error, _} = Inventaire.find_by_isbn("1529355273", Bookpile.HttpMock)
  end
end
