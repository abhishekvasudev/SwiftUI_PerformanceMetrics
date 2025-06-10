import Foundation
import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    private let emptyView = EmptyView()
    
    func searchNews() async {
        guard !searchQuery.isEmpty else { return }
        apiRequestStartTime = Date()
        
        isLoading = true
        error = nil
        
        do {
            let response = try await newsService.fetchNews(query: searchQuery)
            articles = response.articles
            apiRequestEndTime = Date()
            calculateAPIResponseTime()
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
        emptyView.sendRumEvent(event: .componentStart, componentId: "VStackView")
        viewRenderStartTime = Date()
    }
    
    private func calculateAPIResponseTime() {
        guard let startTime = apiRequestStartTime,
              let endTime = apiRequestEndTime else {
            apiResponseTime = "N/A"
            return
        }
        
        let timeInterval = endTime.timeIntervalSince(startTime)
        let milliseconds = Int(timeInterval * 1000)
        apiResponseTime = "\(milliseconds)ms"
    }
    
    func calculateViewRenderTime() {
        guard let startTime = viewRenderStartTime,
              let endTime = viewRenderEndTime else {
            viewRenderTime = "N/A"
            return
        }
        
        let timeInterval = endTime.timeIntervalSince(startTime)
        let milliseconds = Int(timeInterval * 1000)
        viewRenderTime = "\(milliseconds)ms"
    }
    
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchQuery = "WWDC 2025"
    @Published var apiResponseTime = ""
    @Published var viewRenderTime = ""
    @Published var apiRequestStartTime: Date?
    @Published var apiRequestEndTime: Date?
    @Published var viewRenderStartTime: Date?
    @Published var viewRenderEndTime: Date?
    
    private let newsService = NewsService()
    
}

@MainActor
class LazyNewsViewModel: ObservableObject {
    func searchNews() async {
        guard !searchQuery.isEmpty else { return }
        apiRequestStartTime = Date()
        
        isLoading = true
        error = nil
        
        do {
            let response = try await newsService.fetchNews(query: searchQuery)
            articles = response.articles
            apiRequestEndTime = Date()
            calculateAPIResponseTime()
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
        emptyView.sendRumEvent(event: .componentStart, componentId: "LazyVStackView")
        viewRenderStartTime = Date()
    }
    
    private func calculateAPIResponseTime() {
        guard let startTime = apiRequestStartTime,
              let endTime = apiRequestEndTime else {
            apiResponseTime = "N/A"
            return
        }
        
        let timeInterval = endTime.timeIntervalSince(startTime)
        let milliseconds = Int(timeInterval * 1000)
        apiResponseTime = "\(milliseconds)ms"
    }
    
    func calculateViewRenderTime() {
        guard let startTime = viewRenderStartTime,
              let endTime = viewRenderEndTime else {
            viewRenderTime = "N/A"
            return
        }
        
        let timeInterval = endTime.timeIntervalSince(startTime)
        let milliseconds = Int(timeInterval * 1000)
        viewRenderTime = "\(milliseconds)ms"
    }
    
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchQuery = "WWDC 2025"
    @Published var apiResponseTime = ""
    @Published var viewRenderTime = ""
    @Published var apiRequestStartTime: Date?
    @Published var apiRequestEndTime: Date?
    @Published var viewRenderStartTime: Date?
    @Published var viewRenderEndTime: Date?
    
    private let newsService = NewsService()
    private let emptyView = EmptyView()
}
