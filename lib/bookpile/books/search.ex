defmodule Bookpile.Books.Search do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :isbn, :string, virtual: true
  end

  @doc false
  def changeset(search, attrs) do
    search
    |> cast(attrs, [
      :isbn
    ])
    |> validate_required([:isbn])
  end
end
