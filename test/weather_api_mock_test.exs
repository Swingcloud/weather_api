defmodule WeatherAPiMockTest do
  use ExUnit.Case, async: false

  import Mock

  test "use mock to mock the verb of the module" do
    with_mock Finch, [:passthrough],
      request: fn _, _ ->
        {:ok,
         %Finch.Response{
           body: """
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
           """,
           status: 200
         }}
      end do
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
              }} == WeatherApi.get_current_weather("hongkong", WeatherApi.HttpClient)
    end
  end
end
