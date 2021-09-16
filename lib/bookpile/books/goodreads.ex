defmodule Bookpile.Books.Goodreads do
  def find_by_isbn(isbn, http_library \\ HTTPoison) do
    with {:ok, res} <-
           http_library.get(
             "https://www.goodreads.com/search?q=#{isbn}",
             [
               Accept: "text/html"
             ],
             follow_redirect: true
           ),
         {:ok, body} <- get_body(res),
         {:ok, document} <- parse_html(body) do
      extract_book(isbn, document)
    else
      {:error, _} ->
        {:error, "Book not found"}
    end
  end

  defp get_body(%{status_code: 200} = res) do
    {:ok, res.body}
  end

  defp get_body(_res) do
    {:error, "No book"}
  end

  defp parse_html(body) do
    {:ok, document} = Floki.parse_document(body)

    type =
      document
      |> Floki.find("meta[property='og:type']")
      |> Floki.attribute("content")
      |> List.first()

    if type == "books.book" do
      {:ok, document}
    else
      {:error, "No book"}
    end
  end

  defp extract_book(isbn, document) do
    book =
      if String.length(isbn) == 10 do
        %{isbn10: isbn}
      else
        %{isbn13: isbn}
      end

    {:ok,
     Map.merge(book, %{
       title: Floki.find(document, "#bookTitle") |> Floki.text() |> String.trim(),
       description: get_description(document),
       authors: get_authors(document),
       image: Floki.find(document, "#coverImage") |> Floki.attribute("src") |> List.first(),
       page_count: get_page_count(document)
     })}
  end

  defp get_authors(document) do
    Floki.find(document, "#metacol span[itemprop='author']")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
  end

  defp get_page_count(document) do
    result =
      Floki.find(document, "span[itemprop='numberOfPages']") |> Floki.text() |> Integer.parse()

    if result == :error do
      nil
    else
      {page, _} = result
      page
    end
  end

  defp get_description(document) do
    spans = Floki.find(document, "#description span")

    free_text_container =
      Enum.find(spans, fn span ->
        Floki.attribute(span, "id") |> List.first() |> String.match?(~r/freeTextContainer\d+/)
      end)
      |> Floki.text()

    free_text =
      Enum.find(spans, fn span ->
        Floki.attribute(span, "id") |> List.first() |> String.match?(~r/freeText\d+/)
      end)
      |> Floki.text()

    if String.length(free_text) > 0 do
      free_text
    else
      free_text_container
    end
  end
end
