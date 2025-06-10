import SwiftUI
import Foundation

enum NewsError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
}

class NewsService {
    private let apiKey = "9b440c9a8dc44c14b49951f257e7bac2"
    private let baseURL = "https://newsapi.org/v2/everything"
    
    func fetchNews(query: String = "Apple WWDC 2025") async throws -> NewsResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sortBy", value: "popularity"),
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "100")
        ]
        
        guard let url = components?.url else {
            throw NewsError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NewsError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(NewsResponse.self, from: data)
        } catch let error as DecodingError {
            throw NewsError.decodingError(error)
        } catch {
            throw NewsError.networkError(error)
        }
    }
} 
