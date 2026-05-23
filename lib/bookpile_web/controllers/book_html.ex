defmodule BookpileWeb.BookHTML do
  use BookpileWeb, :html

  embed_templates "../templates/book/*"

  def listing_url(entry, isbn) do
    (entry["url"] || "") |> String.replace("{{ISBN}}", isbn)
  end

  def listing_domain(entry) do
    case URI.parse(entry["url"] || "") do
      %URI{host: host} when is_binary(host) -> String.replace(host, ~r/^www\./, "")
      _ -> entry["url"] || "?"
    end
  end

  def shop_glyph(entry) do
    entry |> listing_domain() |> String.first() |> String.upcase()
  end
end
