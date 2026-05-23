defmodule Bookpile.GeoIP do
  @private_prefixes [
    "192.168.",
    "10.",
    "172.16.",
    "172.17.",
    "172.18.",
    "172.19.",
    "172.20.",
    "172.21.",
    "172.22.",
    "172.23.",
    "172.24.",
    "172.25.",
    "172.26.",
    "172.27.",
    "172.28.",
    "172.29.",
    "172.30.",
    "172.31.",
    "fc",
    "fd"
  ]
  @local_ips ~w(127.0.0.1 ::1 0.0.0.0 localhost)
  @default {"Germany", "Berlin"}

  def detect(ip) when is_binary(ip) do
    cond do
      local?(ip) -> @default
      true -> fetch(ip)
    end
  end

  def detect(_), do: @default

  defp local?(ip) do
    ip in @local_ips or Enum.any?(@private_prefixes, &String.starts_with?(ip, &1))
  end

  defp fetch(ip) do
    url = "http://ip-api.com/json/#{ip}?fields=status,country,city"

    case HTTPoison.get(url, [], recv_timeout: 2500, timeout: 2500) do
      {:ok, %{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"status" => "success", "country" => country, "city" => city}} ->
            {country, city}

          _ ->
            @default
        end

      _ ->
        @default
    end
  end
end
