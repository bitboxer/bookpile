defmodule Bookpile.BookSourcesTest do
  use Bookpile.DataCase

  alias Bookpile.BookSources

  describe "regions_json/0" do
    test "returns valid JSON with expected countries" do
      json = BookSources.regions_json()
      assert is_binary(json)
      decoded = Jason.decode!(json)
      assert Map.has_key?(decoded, "Germany")
      assert Map.has_key?(decoded, "United States")
      assert Map.has_key?(decoded, "United Kingdom")
    end

    test "includes shops and libraries for Berlin" do
      decoded = Jason.decode!(BookSources.regions_json())
      berlin = decoded["Germany"]["cities"]["Berlin"]
      assert length(berlin["shops"]) > 0
      assert length(berlin["libraries"]) > 0
    end
  end
end
