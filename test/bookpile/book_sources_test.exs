defmodule Bookpile.BooksTest do
  use Bookpile.DataCase

  alias Bookpile.BookSources
  alias Bookpile.Books.Book

  describe "list_of_countries/0" do
    test "returns a list of countries" do
      countries = BookSources.list_of_countries()
      assert Enum.member?(countries, "de")
      assert Enum.member?(countries, "uk")
    end
  end

  describe "libraries_for" do
    test "returns a list of library websites for a country" do
      websites = BookSources.libraries_for("de", %Book{isbn13: "9783466311040"})
      assert length(websites) > 0
      voebb = List.first(websites)
      assert voebb.name == "Voebb Overdrive"
      assert voebb.url  == "https://voebb.overdrive.com/search?query=9783466311040"

      assert Enum.find(websites, fn website -> website.name == "WorldCat" end) != nil
    end
  end

  describe "bookstores_for" do
    test "returns a list of library websites for a country" do
      websites = BookSources.bookstores_for("de", %Book{isbn13: "9783466311040"})
      assert length(websites) > 0
    end
  end

  describe "used_bookstores_for" do
    test "returns a list of library websites for a country" do
      websites = BookSources.used_bookstores_for("de", %Book{isbn13: "9783466311040"})
      assert length(websites) > 0
    end
  end

  describe "trackers_for" do
    test "returns a list of library websites for a country" do
      websites = BookSources.trackers_for("de", %Book{isbn13: "9783466311040"})
      assert length(websites) > 0
    end
  end
end
