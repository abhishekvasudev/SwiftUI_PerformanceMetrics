import Foundation
import SwiftUI
import Combine

public extension View {
    func sendRumEvent(event: RumEventType,
                      componentId: String = "",
                      visibleViewPercentage: Int? = nil) {
        if !componentId.isEmpty {
            print("Performance Event Received: \(event) || ComponentId: \(componentId)")
        } else {
            print("Performance Event Received: \(event)")
        }
    }
}

public extension UIViewController {
    func sendRumEvent(event: RumEventType,
                     componentId: String = "",
                     visibleViewPercentage: Int? = nil) {
        if !componentId.isEmpty {
            print("Performance Event Received: \(event) || ComponentId: \(componentId)")
        } else {
            print("Performance Event Received: \(event)")
        }
    }
}

public enum RumEventType {
    case pageStart
    case componentStart
    case componentReadyForInteraction
    case pageUnload
}



class Coordinator: ObservableObject {
    
    @Published var path: [NavigationDestination] = []

    func navigate(to destination: NavigationDestination) {
        switch destination {
        case .root:
            path = [.root]
        default:
            path.append(destination)
        }
    }
    
    func back() {
        if path.count > 1 {
            path.removeLast()
        }
    }
}

enum NavigationDestination: Hashable, View {
    case root
    case search
    
    var body: some View {
        switch self {
        case .root:
            ContentView()
        case .search:
            Container {
                SearchView()
            }
        }
    }
}

extension View {
    func navigationDestination<D>(path: Binding<[D]>, navigationBar: Visibility, _ data: D.Type) -> some View where D: Hashable & View {
        NavigationStack(path: path) {
            self.navigationDestination(
                for: data,
                destination: {
                    $0.navigationBar(visibility: navigationBar)
                }
            )
        }
    }
    
    @ViewBuilder
    func navigationBar(visibility: Visibility) -> some View {
        self.toolbar(visibility, for: .navigationBar)
    }
}
