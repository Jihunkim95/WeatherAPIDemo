//
//  WeatherAPI.swift
//  WeatherAPI
//
//  Created by 김지훈 on 2023/11/30.
//

import Foundation


struct WeatherData: Decodable, Hashable {
    let coord: Coord //좌표(위도,적도)
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
}

struct Coord: Decodable,Hashable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable,Hashable {
    let id: Int // 기상조건 ID
    let main: String // 날씨 매개변수 그룹(비, 눈, 구름)
    let description: String?
    let icon: String?
}

struct Main: Decodable, Hashable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    private enum CodingKeys: String, CodingKey {
        case temp, feelsLike = "feels_like", tempMin = "temp_min", tempMax = "temp_max", pressure, humidity
    }
}

struct Wind: Decodable,Hashable {
    let speed: Double
    let deg: Int
}

struct Clouds: Decodable, Hashable {
    let all: Int
}

struct Sys: Decodable, Hashable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

//싱글톤 패턴
class WeatherAPI: ObservableObject {
    static let shared = WeatherAPI()
    
    private init() {}
    
    @Published var posts = [WeatherData]()

    //API 불러오는 테스트용 함수
    func weatherData() -> Void{
        //apiKey 불러오고
        guard let apiKey = apiKey else { return }
        
        //test 서울
        let lat:String = "37.56" //위도
        let lon:String = "126.97" //경도
        
        //url선언
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // 정상적으로 값이 오지 않았을 때 처리
                //                 self.posts = []
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            //             let str = String(decoding: data, as: UTF8.self)
            //             print(str)
            
            //JSON 데이터 Decoder
            do {
                let json = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.posts = [json]
                    print(self.posts)
                }
  
            } catch let error {
                print(error)
                print(error.localizedDescription)
            }
            
        }
        //중단된 작업 재개
        task.resume()
    }

    //plist에서 선언한 API Key 받기
    private var apiKey: String?{
        get{
            let keyfilename = "ApiKeys"
            let api_key = "API_KEY"
            
            //생성한 .plist 파일 경로 불러오기
            guard let filePath = Bundle.main.path(forResource: keyfilename, ofType: "plist") else {
                fatalError("Couldn't find file '\(keyfilename).plist'")
            }
            
            // .plist 파일 내용을 딕셔너리로 받아오기
            let plist = NSDictionary(contentsOfFile: filePath)
            
            // 딕셔너리에서 키 찾기
            guard let value = plist?.object(forKey: api_key) as? String else {
                fatalError("Couldn't find key '\(api_key)'")
            }
            
            return value
        }
    }

}
