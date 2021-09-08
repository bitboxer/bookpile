defmodule Bookpile.Books.GoogleBookApi do
  def find_by_isbn(isbn, http_library \\ HTTPoison) do
    with {:ok, res} <-
           http_library.get(
             "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=#{Application.get_env(:bookpile, :google_api_key)}",
             [
               Accept: "text/json"
             ],
             follow_redirect: true
           ) do
      if res.status_code == 200 do
        with {:ok, json} <- Jason.decode(res.body) do
          parse_json(json)
        end
      else
        {:error, "Book not found"}
      end
    end
  end

  def parse_json(%{"items" => items}) when length(items) > 0 do
    book = List.first(items)
    type_identifiers = parse_identifiers(book)

    {:ok,
     %{
       title: get_in(book, ["volumeInfo", "title"]),
       subtitle: get_in(book, ["volumeInfo", "subtitle"]),
       description: get_in(book, ["volumeInfo", "description"]),
       authors: get_in(book, ["volumeInfo", "authors"]) || [],
       image: get_in(book, ["volumeInfo", "imageLinks", "thumbnail"]),
       isbn10: type_identifiers["ISBN_10"],
       isbn13: type_identifiers["ISBN_13"],
       media_type: get_media_type(book),
       page_count: get_in(book, ["volumeInfo", "pageCount"]),
       published_date: get_in(book, ["volumeInfo", "publishedDate"])
     }}
  end

  def parse_json(_) do
    {:error, "Book not found"}
  end

  defp get_media_type(%{
         "volumeInfo" => %{"printType" => "BOOK"},
         "saleInfo" => %{"isEbook" => true}
       }) do
    "EBOOK"
  end

  defp get_media_type(%{"volumeInfo" => %{"printType" => "BOOK"}}) do
    "BOOK"
  end

  defp get_media_type(%{"volumeInfo" => %{"printType" => "MAGAZINE"}}) do
    "MAGAZINE"
  end

  defp parse_identifiers(book) do
    book
    |> get_in(["volumeInfo", "industryIdentifiers"])
    |> Enum.map(fn item ->
      {item["type"], item["identifier"]}
    end)
    |> Map.new()
  end
end
