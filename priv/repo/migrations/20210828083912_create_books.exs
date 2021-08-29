defmodule Bookpile.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :subtitle, :string
      add :authors, {:array, :string}
      add :description, :text
      add :isbn10, :string
      add :isbn13, :string
      add :image, :string
      add :media_type, :string
      add :page_count, :integer
      add :published_date, :string

      timestamps()
    end

    create index("books", [:isbn10])
    create index("books", [:isbn13])
  end
end
