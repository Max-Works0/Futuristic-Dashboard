import SwiftUI

struct WeatherOverviewView: View {
    @State private var weatherInfo = "Sunny, 28°C"
    @State private var location = "San Francisco"
    @State private var animationOpacity = 0.0

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
    }

    func fetchWeather() {
        // Mock weather update logic
        weatherInfo = "Cloudy, 22°C"
        location = "New York"
    }
}

struct WeatherOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherOverviewView()
    }
}