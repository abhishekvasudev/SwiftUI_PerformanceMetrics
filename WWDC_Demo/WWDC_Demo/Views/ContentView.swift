import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
        .navigationDestination(
            path: $coordinator.path,
            navigationBar: .hidden,
            NavigationDestination.self)
        .environmentObject(coordinator)
    }
    
    private var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var contentView: some View {
        VStack(spacing: 32) {
            appleLogo
            description
            demoButton
        }
    }
    
    private var appleLogo: some View {
        Image(systemName: "apple.logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .foregroundColor(.blue)
    }
    
    private var description: some View {
        VStack(spacing: 32) {
            Text("WWDC 2025")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text("Page Level and Component Level Performance Metrics in SwiftUI")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var demoButton: some View {
        Button {
            coordinator.navigate(to: .search)
        } label: {
            HStack {
                Text("See the Demo")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(16)
        }
        .padding(.horizontal, 32)
        .shadow(radius: 5)
    }

}

#Preview {
    SplashView()
}
