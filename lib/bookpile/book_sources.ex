defmodule Bookpile.BookSources do

  def list_of_countries do
    ["de", "en"]
  end

  def libraries_for(country, book) do
    [
      %{
        name: "Library",
        url: finalize_link_for("https://www.genialokal.de/Suche/?q%5B%5D={{ISBN}}", book)
      }
    ]
  end

  def bookstores_for(country, book) do
    [
      %{
        name: "Bookstore",
        url: finalize_link_for("https://www.genialokal.de/Suche/?q%5B%5D={{ISBN}}", book)
      }
    ]
  end

  def used_bookstores_for(country, book) do
    [
      %{
        name: "Used Book",
        url: finalize_link_for("https://www.genialokal.de/Suche/?q%5B%5D={{ISBN}}", book)
      }
    ]
  end

  def trackers_for(country, book) do
    [
      %{
        name: "Trackers",
        url: finalize_link_for("https://www.genialokal.de/Suche/?q%5B%5D={{ISBN}}", book)
      }
    ]
  end

  defp finalize_link_for(url, book) do
    String.replace(url, "{{ISBN}}", book.isbn13 || book.isbn10)
  end

end
