defmodule Bookpile.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Bookpile.Repo

  alias Bookpile.Books.Book
  alias Bookpile.Books.GoogleBookApi

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
      fetch_book_from_google(isbn, http_library)
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
  Fetches a book from google and returns it as a struct if found,
  nil otherwise.
  """
  def fetch_book_from_google(isbn, http_library \\ HTTPoison) do
    case GoogleBookApi.find_by_isbn(isbn, http_library) do
      {:ok, book} ->
        {:ok, final_book} = create_book(book)
        final_book

      {:error, _} ->
        nil
    end
  end
end
