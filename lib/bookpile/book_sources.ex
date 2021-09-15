defmodule Bookpile.BookSources do
  use GenServer

  @impl true
  def init(data) do
    {:ok, data}
  end

  def start_link(options \\ []) do
    {:ok, json} = get_json()

    GenServer.start_link(__MODULE__, json, options)
  end

  def list_of_countries do
    GenServer.call(__MODULE__, :list_countries)
  end

  def libraries_for(country, book) do
    GenServer.call(__MODULE__, {:list_websites, "libraries", country, book})
  end

  def bookstores_for(country, book) do
    GenServer.call(__MODULE__, {:list_websites, "bookstores", country, book})
  end

  def used_bookstores_for(country, book) do
    GenServer.call(__MODULE__, {:list_websites, "used_bookstores", country, book})
  end

  def trackers_for(country, book) do
    GenServer.call(__MODULE__, {:list_websites, "trackers", country, book})
  end

  @impl true
  def handle_call(:list_countries, _from, json) do
    countries =
      json
      |> Map.keys()
      |> List.delete("everywhere")

    {:reply, countries, json}
  end

  @impl true
  def handle_call({:list_websites, key, country, book}, _from, json) do
    websites =
      finalize_all_links(json[country][key], book) ++
        finalize_all_links(json["everywhere"][key], book)

    {:reply, websites, json}
  end

  defp get_json() do
    json_path = Application.get_env(:bookpile, :website_json_path)

    with {:ok, body} <- File.read(json_path),
         {:ok, json} <- Jason.decode(body),
         do: {:ok, json}
  end

  defp finalize_all_links(nil, _book) do
    []
  end

  defp finalize_all_links(websites, book) do
    Enum.map(websites, fn website ->
      %{
        name: website["name"],
        url: finalize_link_for(website["url"], book)
      }
    end)
  end

  defp finalize_link_for(url, book) do
    String.replace(url, "{{ISBN}}", book.isbn13 || book.isbn10)
  end
end
