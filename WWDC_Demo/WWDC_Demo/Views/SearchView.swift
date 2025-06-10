import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel = NewsViewModel()
    @StateObject private var lazyViewModel = LazyNewsViewModel()
    @State private var isLazyVStack = false
    @State private var vStackQuery = "WWDC 2025"
    @State private var lazyVStackQuery = "WWDC 2025 AI"
    @State private var isVStackLoaded: Bool = false
    @State private var isLazyVStackLoaded: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            backButton
            pickerView
            statsView
            searchBarView
            // Content
            if isLazyVStack {
                lazyContentView
            } else {
                contentView
            }
        }
        .navigationDestination(
            path: $coordinator.path,
            navigationBar: .hidden,
            NavigationDestination.self)
        .environmentObject(coordinator)
    }
    
    private var backButton: some View {
        HStack {
            Button {
                coordinator.back()
            } label: {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.blue)
            }
            Spacer()
        }.padding(.horizontal)
    }
    
    private var pickerView: some View {
        Picker("View Type", selection: $isLazyVStack) {
            Text("VStack").tag(false)
            Text("LazyVStack").tag(true)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var searchBarView: some View {
        HStack {
            TextField("WWDC 2025", text: isLazyVStack ? $lazyVStackQuery : $vStackQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            Button {
                Task {
                    if isLazyVStack {
                        lazyViewModel.searchQuery = lazyVStackQuery
                        await lazyViewModel.searchNews()
                    } else {
                        viewModel.searchQuery = vStackQuery
                        await viewModel.searchNews()
                    }
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    private var statsView: some View {
        HStack {
            Spacer()
            vStackStats
            lazyVStackStats
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var vStackStats: some View {
        HStack {
            VStack {
                Text("API: \(viewModel.apiResponseTime)")
                Text("View: \(viewModel.viewRenderTime)")
            }
            Spacer()
        }
    }
    
    private var lazyVStackStats: some View {
        HStack {
            VStack {
                Text("API: \(lazyViewModel.apiResponseTime)")
                Text("View: \(lazyViewModel.viewRenderTime)")
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            progressView
        } else if let error = viewModel.error {
            errorView(error: error)
        } else if viewModel.articles.isEmpty {
            noResultsView
        } else {
            VStack {
                VStackNewsView(articles: viewModel.articles)
                //MARK:  Challenge: Find a way to get the render of this view
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var lazyContentView: some View {
        if lazyViewModel.isLoading {
            progressView
        } else if let error = lazyViewModel.error {
            errorView(error: error)
        } else if lazyViewModel.articles.isEmpty {
            noResultsView
        } else {
            VStack {
                LazyVStackNewsView(articles: lazyViewModel.articles)
                //MARK:  Challenge: Find a way to get the render of this view
            }
            .padding()
        }
    }
    
    private var progressView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(error: String) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text(error)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    private var noResultsView: some View {
        ContentUnavailableView(
            "No Results",
            systemImage: "magnifyingglass",
            description: Text("")
        )
    }
}
