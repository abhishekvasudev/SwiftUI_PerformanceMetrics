import SwiftUI

struct VStackNewsView: View {
    let articles: [Article]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(articles) { article in
                    NewsArticleCell(article: article)
                }
            }
        }
        .padding()
    }
}

struct NewsArticleCell: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            if let imageURL = article.urlToImage {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .frame(height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                HStack {
                    Text(article.source.name)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text(article.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
} 
