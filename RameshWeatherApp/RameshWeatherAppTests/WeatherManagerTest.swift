//
//  WeatherManagerTest.swift
//  RameshWeatherAppTests
//
//  Created by Ramesh Guddala on 08/04/23.
//
import XCTest
import CoreLocation
@testable import RameshWeatherApp

class WeatherManagerTests: XCTestCase {
    
    var sut: WeatherManager!
    var mockDelegate: MockWeatherManagerDelegate!

    override func setUp() {
        super.setUp()
        sut = WeatherManager()
        mockDelegate = MockWeatherManagerDelegate()
        sut.delegate = mockDelegate
    }

    override func tearDown() {
        sut = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testFetchWeatherCityName() {
        // given
        let cityName = "Sydney"
        
        // when
        sut.fetchWeather(cityName: cityName)
        
        // then
           let expectation = XCTestExpectation(description: "Wait for weather update")
           DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 10)
           
           // Assert that the weather model is not nil
           XCTAssertNotNil(mockDelegate.weatherModel)
    }
    
    func testFetchWeatherLatitudeLongitude() {
        // given
        let latitude = CLLocationDegrees(37.7749)
        let longitude = CLLocationDegrees(-122.4194)
        
        // when
        sut.fetchWeather(lat: latitude, lon: longitude)
        
        // then
        let expectation = XCTestExpectation(description: "Wait for weather update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        
        // Assert that the weather model is not nil
        XCTAssertNotNil(mockDelegate.weatherModel)
    }
    
    func testParseJSON() {
        // given
        let json = """
        {
          "base" : "stations",
          "id" : 6619279,
          "dt" : 1680945441,
          "main" : {
            "temp_max" : 19.859999999999999,
            "humidity" : 55,
            "feels_like" : 18.75,
            "temp_min" : 18.68,
            "temp" : 19.329999999999998,
            "pressure" : 1002
          },
          "coord" : {
            "lon" : 151.21100000000001,
            "lat" : -33.863399999999999
          },
          "wind" : {
            "speed" : 11.32,
            "deg" : 280
          },
          "sys" : {
            "id" : 2002865,
            "country" : "AU",
            "sunset" : 1680939741,
            "type" : 2,
            "sunrise" : 1680898302
          },
          "weather" : [
            {
              "id" : 800,
              "main" : "Clear",
              "icon" : "01n",
              "description" : "clear sky"
            }
          ],
          "visibility" : 10000,
          "clouds" : {
            "all" : 3
          },
          "timezone" : 36000,
          "cod" : 200,
          "name" : "Sydney"
        }
        """
        let jsonData = json.data(using: .utf8)!
        
        // when
        let weatherModel = sut.parseJSON(weatherData: jsonData)
        
        // then
        XCTAssertNotNil(weatherModel)
        XCTAssertEqual(weatherModel!.cityName, "Sydney")
        XCTAssertEqual(weatherModel!.description, "clear sky")
        XCTAssertEqual(weatherModel!.conditionID, 800)
        XCTAssertEqual(weatherModel!.icon, "01n")
        XCTAssertEqual(weatherModel!.temperature, 19.33)
        XCTAssertEqual(weatherModel!.humidity, 55)
        XCTAssertEqual(weatherModel!.wind, 11.32)
        XCTAssertEqual(weatherModel!.sunRiseSeconds, TimeInterval(1680898302.0))
        XCTAssertEqual(weatherModel!.sunSetSeconds, TimeInterval(1680939741.0))
    }
    
}

class MockWeatherManagerDelegate: WeatherManagerDelegate {
    
    var weatherModel: WeatherModel?
    var error: Error?
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        weatherModel = weather
    }
    
    func didFailWithError(error: Error) {
        self.error = error
    }
    
}
