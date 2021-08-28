defmodule Bookpile.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :authors, {:array, :string}
    field :description, :string
    field :image, :string
    field :isbn10, :string
    field :isbn13, :string
    field :subtitle, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :subtitle, :authors, :description, :isbn10, :isbn13, :image])
    |> validate_required([:title, :subtitle, :authors, :description, :isbn10, :isbn13, :image])
  end
end
