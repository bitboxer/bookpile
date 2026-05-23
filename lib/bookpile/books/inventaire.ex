defmodule Bookpile.Books.Inventaire do
  @base_url "https://inventaire.io"
  @headers [{"User-Agent", "bookpile.org"}, {"Accept", "application/json"}]

  def find_by_isbn(isbn, http_library \\ HTTPoison) do
    url = "#{@base_url}/api/entities/by-uris?uris=isbn:#{isbn}"

    case http_library.get(url, @headers, follow_redirect: true) do
      {:ok, %{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> parse_response(data)
          _ -> {:error, "Failed to parse response"}
        end

      _ ->
        {:error, "Request failed"}
    end
  end

  defp parse_response(%{"entities" => entities}) when map_size(entities) == 0 do
    {:error, "Not found"}
  end

  defp parse_response(%{"entities" => entities, "redirects" => redirects}) do
    entity_id = redirects |> Map.values() |> List.first()
    entity = entities[entity_id]

    if entity do
      {:ok, extract_book(entity)}
    else
      {:error, "Entity not found"}
    end
  end

  defp parse_response(_), do: {:error, "Unexpected response"}

  defp extract_book(entity) do
    title =
      get_in(entity, ["labels", "fromclaims"]) ||
        (get_in(entity, ["claims", "wdt:P1476"]) || []) |> List.first()

    image =
      case get_in(entity, ["image", "url"]) do
        nil -> nil
        url -> "#{@base_url}#{url}"
      end

    %{
      title: title,
      image: image,
      isbn13: (get_in(entity, ["claims", "wdt:P212"]) || []) |> List.first(),
      isbn10: (get_in(entity, ["claims", "wdt:P957"]) || []) |> List.first(),
      published_date: (get_in(entity, ["claims", "wdt:P577"]) || []) |> List.first()
    }
  end
end
