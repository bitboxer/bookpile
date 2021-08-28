defmodule Bookpile.Repo do
  use Ecto.Repo,
    otp_app: :bookpile,
    adapter: Ecto.Adapters.Postgres
end
