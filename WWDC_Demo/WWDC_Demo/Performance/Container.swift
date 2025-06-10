import SwiftUI

public struct Container: View {
    private let content: () -> any View
    internal var deInitHelper = DeInitHelper()
    
    public init(content: @escaping () -> any View) {
        self.content = content
    }
    
    public var body: some View {
        AnyView(
            content()
        )
        .onAppear {
            sendRumEvent(event: .pageStart)
        }
    }
}

class DeInitHelper {
    let emptyView = EmptyView()
    deinit {
        emptyView.sendRumEvent(event: .pageUnload)
    }
}




public struct RootView: View {
    public var body: some View {
        Container {
            HomeView()
        }
    }
}






public struct HomeView: View {
    public var body: some View {
        Text("123")
    }
}



