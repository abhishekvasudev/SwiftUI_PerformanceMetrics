import SwiftUI

struct LazyVStackNewsView: View {
    let articles: [Article]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(articles) { article in
                    NewsArticleCell(article: article)
                }
            }
        }
        .padding()
    }
} 
