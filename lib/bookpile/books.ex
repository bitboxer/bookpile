defmodule Bookpile.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Bookpile.Repo

  alias Bookpile.Books.Book
  alias Bookpile.Books.GoogleBookApi
  alias Bookpile.Books.Goodreads
  alias Bookpile.Books.Search

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book by its ISBN.

  If the book does not exist, it will try to fetch it from google and
  store it in the database.

  Returns nil if the book does not exist.
  """
  def get_book_by_isbn(isbn, http_library \\ HTTPoison) do
    query =
      from b in Book,
        where: b.isbn10 == ^isbn or b.isbn13 == ^isbn

    result = Repo.one(query)

    if result == nil do
      fetch_from_web(isbn, http_library)
    else
      result
    end
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  @doc """
  Fetches a book from google and goodreads and merges both
  """
  def fetch_from_web(isbn, http_library) do
    google_book = fetch_book_from_google(isbn, http_library)

    goodreads_book = fetch_book_from_goodreads(isbn, http_library)

    goodreads_book =
      if goodreads_book == nil && google_book && google_book.isbn13 && google_book.isbn13 != isbn do
        goodreads_book = fetch_book_from_goodreads(google_book.isbn13, http_library)
      else
        goodreads_book
      end

    book =
      cond do
        google_book == nil ->
          goodreads_book

        goodreads_book == nil ->
          google_book

        true ->
          join_books(google_book, goodreads_book)
      end

    {:ok, stored_book} = create_book(book)
    stored_book
  end

  defp join_books(google_book, goodreads_book) do
    description =
      if String.length(google_book.description || "") >
           String.length(goodreads_book.description || "") do
        google_book.description
      else
        goodreads_book.description
      end

    %{
      title: google_book.title || goodreads_book.subtitle,
      subtitle: google_book.subtitle,
      description: description,
      authors: google_book.authors,
      image: goodreads_book.image || google_book.image,
      isbn10: google_book.isbn10 || goodreads_book.isbn10,
      isbn13: google_book.isbn13 || goodreads_book.isbn13,
      media_type: google_book.media_type,
      page_count: google_book.page_count || goodreads_book.page_count,
      published_date: google_book.published_date
    }
  end

  @doc """
  Fetches a book from google and returns it as a struct if found,
  nil otherwise.
  """
  def fetch_book_from_google(isbn, http_library \\ HTTPoison) do
    case GoogleBookApi.find_by_isbn(isbn, http_library) do
      {:ok, book} ->
        book

      {:error, _} ->
        nil
    end
  end

  @doc """
  Fetches a book from goodreads and returns it as a struct if found,
  nil otherwise.
  """
  def fetch_book_from_goodreads(isbn, http_library \\ HTTPoison) do
    case Goodreads.find_by_isbn(isbn, http_library) do
      {:ok, book} ->
        book

      {:error, _} ->
        nil
    end
  end

  def search_changeset(attrs) do
    %Search{}
    |> Search.changeset(attrs)
  end
end
