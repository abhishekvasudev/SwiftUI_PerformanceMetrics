import SwiftUI

@main
struct WWDC_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

struct SplashView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        VStack {
            Color.clear
        }.onAppear {
            coordinator.navigate(to: .root)
        }
        .navigationDestination(
            path: $coordinator.path,
            navigationBar: .hidden,
            NavigationDestination.self)
        .environmentObject(coordinator)
    }
}
