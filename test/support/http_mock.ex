defmodule Bookpile.HttpMock do
  @google_api_key Application.compile_env(:bookpile, :google_api_key)

  def get(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:1529355273&key=#{@google_api_key}",
        [
          Accept: "text/json"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/google_book_api.json")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:CANNOTBEFOUND&key=#{@google_api_key}",
        [
          Accept: "text/json"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/google_book_api_not_found.json")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:9978466673&key=#{@google_api_key}",
        [
          Accept: "text/json"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/google_book_api_not_found.json")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:006095485X&key=#{@google_api_key}",
        [
          Accept: "text/json"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/google_book_api_not_found.json")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:9783570165782&key=#{@google_api_key}",
        [
          Accept: "text/json"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/google_book_api_no_image.json")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:3789129445&key=#{@google_api_key}",
        [
          Accept: "text/json"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/google_book_api_pipi.json")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.googleapis.com/books/v1/volumes?q=isbn:1548520500&key=#{@google_api_key}",
        [
          Accept: "text/json"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/google_book_api_the_churn.json")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.goodreads.com/search?q=3847900781",
        [
          Accept: "text/html"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/goodreads_herzschlag_ins_gesicht.html")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end

  def get(
        "https://www.goodreads.com/search?q=notfound",
        [
          Accept: "text/html"
        ],
        follow_redirect: true
      ) do
    {:ok, html} = File.read("./test/support/data/goodreads_not_found.html")
    {:ok, %{status_code: 200, body: html, headers: []}}
  end
end
