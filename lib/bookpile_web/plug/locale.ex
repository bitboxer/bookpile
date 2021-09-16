defmodule BookpileWeb.Plug.Locale do
  import Plug.Conn

  @valid_locales ["de", "en"]

  def init(_opts), do: nil

  def call(conn, _opts) do
    case fetch_locale(conn) do
      nil -> conn
      locale -> update_locale(conn, locale)
    end
  end

  defp fetch_locale(conn) do
    clean_param(
      conn.params["locale"] || get_session(conn, :locale) ||
        get_browser_lang(get_req_header(conn, "accept-language"))
    )
  end

  defp clean_param(locale) do
    if Enum.member?(@valid_locales, locale) do
      locale
    else
      nil
    end
  end

  defp get_browser_lang([language]) do
    language
    |> String.split(",")
    |> Enum.map(fn locale -> ~r/[^a-zA-Z]/ |> Regex.split(locale) |> List.first() end)
    |> Enum.filter(fn locale -> Enum.member?(@valid_locales, locale) end)
    |> List.first()
  end

  defp get_browser_lang([]) do
    "en"
  end

  defp update_locale(conn, locale) do
    Gettext.put_locale(BookpileWeb.Gettext, locale)
    conn |> put_session(:locale, locale)
  end
end
