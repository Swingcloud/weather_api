import Config

config :weather_api,
  base_url: System.get_env("WEATHER_API_BAS_URL") || "http://localhost:3000",
  api_key: System.get_env("API_KEY") || "key",
  http_client: WeatherApi.HttpClient

import_config "#{Mix.env()}.exs"
