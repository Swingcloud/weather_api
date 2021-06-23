defmodule WeatherApi do
  @moduledoc """
  Documentation for `WeatherApi`.
  """

  @http_client Application.compile_env(:weather_api, :http_client)

  @spec get_current_weather(city :: String.t()) :: {:ok, map()} | {:error, term()}
  def get_current_weather(city) do
    @http_client.get_current_weather(city)
  end

  def get_current_weather(city, http_client) do
    http_client.get_current_weather(city)
  end
end
