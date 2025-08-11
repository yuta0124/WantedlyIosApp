import SwiftUI

struct CachedAsyncImageView<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var loadedImage: UIImage?
    @State private var isLoading = false
    @State private var hasError = false
    
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let loadedImage = loadedImage {
                content(Image(uiImage: loadedImage))
            } else if isLoading {
                placeholder()
            } else if hasError {
                ImageErrorView()
            } else {
                placeholder()
                    .onAppear {
                        loadImage()
                    }
            }
        }
        .onChange(of: url) { _, newURL in
            if newURL != url {
                loadedImage = nil
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        guard let url = url, loadedImage == nil, !isLoading else { return }
        
        isLoading = true
        
        // キャッシュから画像を取得
        if let cachedImage = ImageCache.shared.get(forKey: url.absoluteString) {
            self.loadedImage = cachedImage
            self.isLoading = false
            return
        }
        
        // ネットワークから画像を取得
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let data = data, let image = UIImage(data: data) {
                    // キャッシュに保存
                    ImageCache.shared.set(image, forKey: url.absoluteString)
                    self.loadedImage = image
                    self.hasError = false
                } else {
                    self.hasError = true
                }
            }
        }.resume()
    }
}

// 画像キャッシュクラス
final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // メモリ制限を設定
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 50 // 50MB
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}

extension CachedAsyncImageView {
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content
    ) where Placeholder == EmptyView {
        self.init(url: url, scale: scale, transaction: transaction, content: content) {
            EmptyView()
        }
    }
}
