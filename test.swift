import SwiftUI
import CoreLocation

struct WeatherOverviewView: View {
    @State private var weatherInfo = "Fetching..."
    @State private var location = "Your Location"
    @State private var animationOpacity = 0.0
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .purple, .pink]),
                           startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // App Title
                Text("☀️ Weather Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                // Animated Weather Icon
                Text("🌤️")
                    .font(.system(size: 100))
                    .opacity(animationOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            animationOpacity = 1.0
                        }
                    }

                // Location
                Text(location)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)

                // Weather Info
                Text(weatherInfo)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Spacer()

                // Refresh Button
                Button(action: {
                    fetchWeather()
                }) {
                    Text("🔄 Refresh")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
        .onAppear {
            fetchWeather()
        }
    }

    func fetchWeather() {
        guard let lat = locationManager.latitude, let lon = locationManager.longitude else {
            weatherInfo = "Unable to get location"
            return
        }

        // Replace YOUR_API_KEY with your actual OpenWeatherMap API key
        let apiKey = "YOUR_API_KEY"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        weatherInfo = "\(weatherResponse.weather[0].description.capitalized), \(Int(weatherResponse.main.temp))°C"
                        location = weatherResponse.name
                    }
                } catch {
                    DispatchQueue.main.async {
                        weatherInfo = "Failed to fetch weather"
                    }
                }
            }
        }.resume()
    }
}

struct WeatherResponse: Codable {
    struct Weather: Codable {
        let description: String
    }
    struct Main: Codable {
        let temp: Double
    }
    let weather: [Weather]
    let main: Main
    let name: String
}

// Location Manager for fetching the user's location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var latitude: Double?
    @Published var longitude: Double?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}