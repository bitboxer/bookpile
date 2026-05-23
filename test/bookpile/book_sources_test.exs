defmodule Bookpile.BookSourcesTest do
  use Bookpile.DataCase

  alias Bookpile.BookSources

  describe "stats/0" do
    test "returns country, city and shop counts matching the actual data" do
      stats = BookSources.stats()
      decoded = Jason.decode!(BookSources.regions_json())

      expected_countries = map_size(decoded)

      expected_cities =
        decoded
        |> Map.values()
        |> Enum.reduce(0, fn c, acc -> acc + map_size(c["cities"]) end)

      assert stats.countries == expected_countries
      assert stats.cities == expected_cities
      assert stats.shops > 0
    end

    test "shop count covers local and national entries" do
      stats = BookSources.stats()
      # Berlin alone has 4 local + 7 national German shops, so total must exceed that
      assert stats.shops > 11
    end
  end

  describe "regions_json/0" do
    test "returns valid JSON with expected countries" do
      json = BookSources.regions_json()
      assert is_binary(json)
      decoded = Jason.decode!(json)
      assert Map.has_key?(decoded, "Germany")
      assert Map.has_key?(decoded, "United States")
      assert Map.has_key?(decoded, "United Kingdom")
    end

    test "includes shops, libraries, and trackers for Berlin" do
      decoded = Jason.decode!(BookSources.regions_json())
      berlin = decoded["Germany"]["cities"]["Berlin"]
      assert length(berlin["local_shops"]) > 0
      assert length(berlin["national_shops"]) > 0
      assert length(berlin["libraries"]) > 0
      assert length(berlin["trackers"]) > 0
    end
  end
end
