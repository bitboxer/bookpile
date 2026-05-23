defmodule Bookpile.BookSources do
  @regions %{
    "Germany" => %{
      "flag" => "🇩🇪",
      "cities" => %{
        "Berlin" => %{
          "shops" => [
            %{"name" => "Genialokal", "note" => "Network of 700+ German indie bookshops", "domain" => "genialokal.de"},
            %{"name" => "Hugendubel", "note" => "Munich-founded chain, ships from Germany", "domain" => "hugendubel.de"},
            %{"name" => "Thalia", "note" => "Largest German-language bookshop chain", "domain" => "thalia.de"},
            %{"name" => "Buchhandlung Walther König", "note" => "Berlin-Mitte, art & literature specialist", "domain" => "buchhandlung-walther-koenig.de"},
            %{"name" => "Bookshop.org DE", "note" => "Profits to independent shops", "domain" => "bookshop.org/de"},
            %{"name" => "Amazon.de", "note" => "Ships from Leipzig & Bad Hersfeld", "domain" => "amazon.de"}
          ],
          "libraries" => [
            %{"name" => "Zentral- und Landesbibliothek Berlin", "note" => "Largest public library in Berlin", "domain" => "voebb.de"},
            %{"name" => "Staatsbibliothek zu Berlin", "note" => "Research library, Potsdamer Straße & Unter den Linden", "domain" => "staatsbibliothek-berlin.de"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        },
        "Munich" => %{
          "shops" => [
            %{"name" => "Genialokal", "note" => "Network of 700+ German indie bookshops", "domain" => "genialokal.de"},
            %{"name" => "Hugendubel", "note" => "Flagship Marienplatz, Munich since 1893", "domain" => "hugendubel.de"},
            %{"name" => "Thalia", "note" => "Largest German-language bookshop chain", "domain" => "thalia.de"},
            %{"name" => "Lehmkuhl", "note" => "Schwabing institution since 1903", "domain" => "lehmkuhl.net"},
            %{"name" => "Bookshop.org DE", "note" => "Profits to independent shops", "domain" => "bookshop.org/de"},
            %{"name" => "Amazon.de", "note" => "Ships from Leipzig & Bad Hersfeld", "domain" => "amazon.de"}
          ],
          "libraries" => [
            %{"name" => "Münchner Stadtbibliothek", "note" => "Public library, 23 branches across Munich", "domain" => "muenchner-stadtbibliothek.de"},
            %{"name" => "Bayerische Staatsbibliothek", "note" => "One of Europe's largest research libraries", "domain" => "bsb-muenchen.de"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        },
        "Hamburg" => %{
          "shops" => [
            %{"name" => "Genialokal", "note" => "Network of 700+ German indie bookshops", "domain" => "genialokal.de"},
            %{"name" => "Hugendubel", "note" => "Munich-founded chain, ships from Germany", "domain" => "hugendubel.de"},
            %{"name" => "Thalia", "note" => "Largest German-language bookshop chain — HQ in Hamburg", "domain" => "thalia.de"},
            %{"name" => "Cohen + Dobernigg", "note" => "Sternschanze, since 1976", "domain" => "codobuch.de"},
            %{"name" => "Bookshop.org DE", "note" => "Profits to independent shops", "domain" => "bookshop.org/de"},
            %{"name" => "Amazon.de", "note" => "Ships from Leipzig & Bad Hersfeld", "domain" => "amazon.de"}
          ],
          "libraries" => [
            %{"name" => "Bücherhallen Hamburg", "note" => "32 public library branches", "domain" => "buecherhallen.de"},
            %{"name" => "Staats- und Universitätsbibliothek Hamburg", "note" => "Research library", "domain" => "sub.uni-hamburg.de"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        }
      }
    },
    "United States" => %{
      "flag" => "🇺🇸",
      "cities" => %{
        "New York" => %{
          "shops" => [
            %{"name" => "Bookshop.org", "note" => "Profits go to indie bookshops", "domain" => "bookshop.org"},
            %{"name" => "Strand", "note" => "18 miles of books, since 1927", "domain" => "strandbooks.com"},
            %{"name" => "McNally Jackson", "note" => "SoHo, Nolita, Williamsburg, Seaport", "domain" => "mcnallyjackson.com"},
            %{"name" => "Powell's", "note" => "Portland-based, ships nationwide", "domain" => "powells.com"},
            %{"name" => "Barnes & Noble", "note" => "Nationwide chain", "domain" => "barnesandnoble.com"},
            %{"name" => "Amazon", "note" => "Ships from regional warehouses", "domain" => "amazon.com"}
          ],
          "libraries" => [
            %{"name" => "New York Public Library", "note" => "92 locations across NYC", "domain" => "nypl.org"},
            %{"name" => "Brooklyn Public Library", "note" => "60 branches in Brooklyn", "domain" => "bklynlibrary.org"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        },
        "San Francisco" => %{
          "shops" => [
            %{"name" => "Bookshop.org", "note" => "Profits go to indie bookshops", "domain" => "bookshop.org"},
            %{"name" => "City Lights", "note" => "Beat-era landmark in North Beach", "domain" => "citylights.com"},
            %{"name" => "Green Apple Books", "note" => "Richmond District since 1967", "domain" => "greenapplebooks.com"},
            %{"name" => "Powell's", "note" => "Portland-based, ships nationwide", "domain" => "powells.com"},
            %{"name" => "Barnes & Noble", "note" => "Nationwide chain", "domain" => "barnesandnoble.com"},
            %{"name" => "Amazon", "note" => "Ships from regional warehouses", "domain" => "amazon.com"}
          ],
          "libraries" => [
            %{"name" => "San Francisco Public Library", "note" => "28 neighborhood branches", "domain" => "sfpl.org"},
            %{"name" => "Internet Archive", "note" => "Headquartered in SF", "domain" => "archive.org"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        }
      }
    },
    "United Kingdom" => %{
      "flag" => "🇬🇧",
      "cities" => %{
        "London" => %{
          "shops" => [
            %{"name" => "Bookshop.org UK", "note" => "Supports independent bookshops", "domain" => "uk.bookshop.org"},
            %{"name" => "Hive", "note" => "Ships via your chosen local indie", "domain" => "hive.co.uk"},
            %{"name" => "Foyles", "note" => "Charing Cross flagship", "domain" => "foyles.co.uk"},
            %{"name" => "Waterstones", "note" => "UK's largest book chain", "domain" => "waterstones.com"},
            %{"name" => "Blackwell's", "note" => "Oxford-founded, ships UK-wide", "domain" => "blackwells.co.uk"},
            %{"name" => "Amazon UK", "note" => "Ships from UK fulfilment centres", "domain" => "amazon.co.uk"}
          ],
          "libraries" => [
            %{"name" => "British Library", "note" => "National library, St Pancras", "domain" => "bl.uk"},
            %{"name" => "London Libraries Consortium", "note" => "Search across 17 London boroughs", "domain" => "londonlibraries.gov.uk"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        }
      }
    },
    "France" => %{
      "flag" => "🇫🇷",
      "cities" => %{
        "Paris" => %{
          "shops" => [
            %{"name" => "Place des Libraires", "note" => "Réseau of 1,200+ French indie shops", "domain" => "placedeslibraires.fr"},
            %{"name" => "Librairie Galignani", "note" => "First English bookshop on the Continent, rue de Rivoli", "domain" => "galignani.fr"},
            %{"name" => "Fnac", "note" => "Largest French cultural chain", "domain" => "fnac.com"},
            %{"name" => "Cultura", "note" => "Books, music, hobbies — ships France-wide", "domain" => "cultura.com"},
            %{"name" => "Decitre", "note" => "Lyon-founded chain, ships France-wide", "domain" => "decitre.fr"},
            %{"name" => "Amazon.fr", "note" => "Ships from French fulfilment centres", "domain" => "amazon.fr"}
          ],
          "libraries" => [
            %{"name" => "Bibliothèque nationale de France", "note" => "National library, four Paris sites", "domain" => "bnf.fr"},
            %{"name" => "Bibliothèques de la Ville de Paris", "note" => "57 public lending libraries in Paris", "domain" => "bibliotheques.paris.fr"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        }
      }
    },
    "Netherlands" => %{
      "flag" => "🇳🇱",
      "cities" => %{
        "Amsterdam" => %{
          "shops" => [
            %{"name" => "Athenaeum Boekhandel", "note" => "Spui square, Amsterdam since 1966", "domain" => "athenaeum.nl"},
            %{"name" => "Libris", "note" => "Réseau of 75+ Dutch indie bookshops", "domain" => "libris.nl"},
            %{"name" => "American Book Center", "note" => "English-language, Spui Amsterdam", "domain" => "abc.nl"},
            %{"name" => "Bol", "note" => "Dutch online retailer", "domain" => "bol.com"},
            %{"name" => "Bookshop.org", "note" => "Profits to indie bookshops", "domain" => "bookshop.org"},
            %{"name" => "Amazon.nl", "note" => "Ships within the Netherlands", "domain" => "amazon.nl"}
          ],
          "libraries" => [
            %{"name" => "Openbare Bibliotheek Amsterdam", "note" => "OBA — 26 locations across Amsterdam", "domain" => "oba.nl"},
            %{"name" => "Koninklijke Bibliotheek", "note" => "National library, Den Haag", "domain" => "kb.nl"},
            %{"name" => "WorldCat", "note" => "Search 17,000+ libraries worldwide", "domain" => "worldcat.org"},
            %{"name" => "Open Library", "note" => "Internet Archive's open lending library", "domain" => "openlibrary.org"}
          ]
        }
      }
    }
  }

  def regions_json, do: Jason.encode!(@regions)
end
