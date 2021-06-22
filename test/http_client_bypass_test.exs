defmodule WeatherApi.HttpClientBypassTest do
  use ExUnit.Case, async: true

  alias WeatherApi.HttpClient

  setup do
    bypass = Bypass.open()
    base_url = Application.get_env(:weather_api, :base_url)
    test_url = %{URI.parse(base_url) | port: bypass.port} |> URI.to_string()
    Application.put_env(:weather_api, :base_url, test_url)

    {:ok, bypass: bypass}
  end

  test "client 400 response", %{bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      Plug.Conn.resp(conn, 400, """
      {
        "error": {
          "code": 1006,
          "message": "No matching location found."
        }
      }
      """)
    end)

    assert {:ok, %{"error" => %{"code" => 1006, "message" => "No matching location found."}}} =
             WeatherApi.HttpClient.get_current_weather("hongkong")
  end

  test "client can get the success response", %{bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, """
      {
        "location": {
          "name": "Hongkong",
          "region": "",
          "country": "Hongkong",
          "lat": 22.28,
          "lon": 114.15,
          "tz_id": "Asia/Hong_Kong",
          "localtime_epoch": 1624372020,
          "localtime": "2021-06-22 22:27"
        },
        "current": {
          "last_updated_epoch": 1624371300,
          "last_updated": "2021-06-22 22:15",
          "temp_c": 26.7,
          "temp_f": 80.1,
          "is_day": 0,
          "condition": {
            "text": "Light drizzle",
            "icon": "//cdn.weatherapi.com/weather/64x64/night/266.png",
            "code": 1153
          },
          "wind_mph": 5.6,
          "wind_kph": 9.0,
          "wind_degree": 154,
          "wind_dir": "SSE",
          "pressure_mb": 1004.0,
          "pressure_in": 30.1,
          "precip_mm": 0.1,
          "precip_in": 0.0,
          "humidity": 81,
          "cloud": 73,
          "feelslike_c": 30.1,
          "feelslike_f": 86.2,
          "vis_km": 7.3,
          "vis_miles": 4.0,
          "uv": 6.0,
          "gust_mph": 8.1,
          "gust_kph": 13.0
        }
      }
      """)
    end)

    assert {:ok,
            %{
              "current" => %{
                "cloud" => 73,
                "condition" => %{
                  "code" => 1153,
                  "icon" => "//cdn.weatherapi.com/weather/64x64/night/266.png",
                  "text" => "Light drizzle"
                },
                "feelslike_c" => 30.1,
                "feelslike_f" => 86.2,
                "gust_kph" => 13.0,
                "gust_mph" => 8.1,
                "humidity" => 81,
                "is_day" => 0,
                "last_updated" => "2021-06-22 22:15",
                "last_updated_epoch" => 1_624_371_300,
                "precip_in" => 0.0,
                "precip_mm" => 0.1,
                "pressure_in" => 30.1,
                "pressure_mb" => 1004.0,
                "temp_c" => 26.7,
                "temp_f" => 80.1,
                "uv" => 6.0,
                "vis_km" => 7.3,
                "vis_miles" => 4.0,
                "wind_degree" => 154,
                "wind_dir" => "SSE",
                "wind_kph" => 9.0,
                "wind_mph" => 5.6
              },
              "location" => %{
                "country" => "Hongkong",
                "lat" => 22.28,
                "localtime" => "2021-06-22 22:27",
                "localtime_epoch" => 1_624_372_020,
                "lon" => 114.15,
                "name" => "Hongkong",
                "region" => "",
                "tz_id" => "Asia/Hong_Kong"
              }
            }} = WeatherApi.HttpClient.get_current_weather("hongkong")
  end
end
