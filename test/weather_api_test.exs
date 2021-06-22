defmodule WeatherApiTest do
  use ExUnit.Case
  doctest WeatherApi

  test "greets the world" do
    assert WeatherApi.hello() == :world
  end
end
