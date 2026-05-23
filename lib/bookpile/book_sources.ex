defmodule Bookpile.BookSources do
  @json_path Path.join([__DIR__, "..", "..", "priv", "websites.json"]) |> Path.expand()
  @external_resource @json_path

  raw = File.read!(@json_path) |> Jason.decode!()

  everywhere_shops = get_in(raw, ["everywhere", "shops"]) || []
  everywhere_libraries = get_in(raw, ["everywhere", "libraries"]) || []

  # Build merged regions: each city contains city-specific + country-wide + everywhere listings.
  regions =
    (raw["regions"] || %{})
    |> Enum.map(fn {country, country_data} ->
      flag = country_data["flag"] || ""
      country_shops = country_data["shops"] || []
      country_libraries = country_data["libraries"] || []

      cities =
        (country_data["cities"] || %{})
        |> Enum.map(fn {city, city_data} ->
          merged_shops = (city_data["shops"] || []) ++ country_shops ++ everywhere_shops
          merged_libraries = (city_data["libraries"] || []) ++ country_libraries ++ everywhere_libraries
          {city, %{"shops" => merged_shops, "libraries" => merged_libraries}}
        end)
        |> Map.new()

      {country, %{"flag" => flag, "cities" => cities}}
    end)
    |> Map.new()

  @regions regions
  @regions_json Jason.encode!(regions)

  def regions_json, do: @regions_json

  def listings_for(country, city) do
    get_in(@regions, [country, "cities", city]) ||
      %{"shops" => [], "libraries" => []}
  end

  # Returns the best {country, city} pair we actually have data for.
  # Falls back to the first city in the matched country, then to Germany/Berlin.
  def best_match(country, city) do
    cond do
      get_in(@regions, [country, "cities", city]) != nil ->
        {country, city}

      @regions[country] != nil ->
        first_city = @regions[country]["cities"] |> Map.keys() |> List.first()
        {country, first_city}

      true ->
        {"Germany", "Berlin"}
    end
  end
end
