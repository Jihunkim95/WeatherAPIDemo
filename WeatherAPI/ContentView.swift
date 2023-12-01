//
//  ContentView.swift
//  WeatherAPI
//
//  Created by 김지훈 on 2023/11/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherAPI = WeatherAPI.shared
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(weatherAPI.posts, id: \.self){ result in
                    VStack(alignment: .leading, spacing: 5){
                        Text("\(result.name)")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .bold()
                        
                        Text("\(Int(round(result.main.temp) - 273.15)) °")
                            .font(.largeTitle)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        //이미지URL형식 : https://openweathermap.org/img/wn/10d@2x.png
                        //비동기 이미지 API데이터때문에 사용
                        let urlImage = "https://openweathermap.org/img/wn/\(result.weather[0].icon ?? "" )@2x.png"
                        AsyncImage(url: URL(string:  urlImage)){ image in
                                image.image?.resizable()
                            }
                        .frame(width: 40, height: 40)
                        
                        Text("\(result.weather[0].main)")
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .bold()
                        HStack{
                            Text("최고 : \(Int(round(result.main.tempMax) - 273.15)) °C")
                                .font(.subheadline)
                            Text("최저 : \(Int(round(result.main.tempMin) - 273.15)) °C")
                                .font(.subheadline)
                        }


                    }
                }
            }
            

        }
        .padding()
        .onAppear() {
            weatherAPI.weatherData()
        }
        
    }
}

#Preview {
    ContentView()
}
