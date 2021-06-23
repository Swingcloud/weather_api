defmodule WeatherApi.HttpClientBehaviour do
  @callback get_current_weather(city :: String.t()) :: {:ok, map} | {:error, term()}
end

defmodule WeatherApi.HttpClient do
  @behaviour WeatherApi.HttpClientBehaviour

  alias Finch.Response

  @impl true
  def get_current_weather(city) do
    encoded_query =
      URI.encode_query(%{key: Application.get_env(:weatehr_api, :api_key), city: city})

    path = "#{base_url()}/current.json" <> "?" <> encoded_query

    :get
    |> Finch.build(path)
    |> Finch.request(__MODULE__)
    |> handle_response()
  end

  def handle_response({:ok, %Response{status: 200, body: body}}) do
    Jason.decode(body)
  end

  def handle_response({:ok, %Response{status: status, body: body}}) when status in 400..499 do
    Jason.decode(body)
  end

  def handle_response({:ok, %Response{status: status} = resp}) do
    {:error, %{status_code: status, resp: resp}}
  end

  def handle_response({:error, error}) do
    {:error, error}
  end

  def base_url do
    Application.get_env(:weather_api, :base_url)
  end
end
