defmodule WeatherApiHammoxTest do
  use ExUnit.Case, async: true

  alias WeatherApi.HttpClientMock

  import Hammox

  setup :verify_on_exit!

  describe "get current weather" do
    test "success" do
      HttpClientMock
      |> expect(:get_current_weather, fn city ->
        assert city == "hongkong"
        expected_response()
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
              }} = WeatherApi.get_current_weather("hongkong")
    end

    test "hammox will check the type of the argument" do
      HttpClientMock
      |> expect(:get_current_weather, fn _city ->
        expected_response()
      end)

      assert catch_error(WeatherApi.get_current_weather(123)) == %Hammox.TypeMatchError{
               message:
                 "\n1st argument value 123 does not match 1st parameter's type String.t() (\"city\").\n  Value 123 does not match type <<_::_*8>>."
             }
    end

    test "hammox will check the type of the output" do
      HttpClientMock
      |> expect(:get_current_weather, fn _city ->
        {true, true}
      end)

      assert catch_error(WeatherApi.get_current_weather("hk")) == %Hammox.TypeMatchError{
        __exception__: true,
        message: "\nReturned value {true, true} does not match type {:ok, map()} | {:error, term()}.\n  Value {true, true} does not match type {:ok, map()} | {:error, term()}.\n    1st tuple element true does not match 1st element type :error.\n      Value true does not match type :error."
      }
    end
  end

  def expected_response do
    {:ok,
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
     }}
  end
end
