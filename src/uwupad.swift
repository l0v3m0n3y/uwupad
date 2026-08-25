import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class Uwupad {
    private let api = "https://uwupad.me/api"
    private let music_api = "https://uwupad.me/music/api"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "Connection": "keep-alive",
            "Accept-Encoding": "deflate, zstd",
            "Accept-Language": "en-US,en;q=0.9",
            "Host": "uwupad.me",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]
    }
    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    
    public func getSounds(offset: Int, geo: String, sortBy: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "beta": "false",
            "v3": "true",
            "tab": "fyp",
            "limit": "15",
            "offset": String(offset),
            "geo": geo,
            "content_langs": "en,ru,sfx",
            "sort_by": sortBy
        ]
        
        return try await fetchJSON(
            from: "\(api)/sounds/",
            method: .get,
            queryParameters: queryParameters
        )
    }
    
    public func getSoundComments(id: Int, skip: Int, sort: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "skip": String(skip),
            "limit": "10",
            "sort": sort
        ]
        
        return try await fetchJSON(
            from: "\(api)/sounds/\(id)/comments",
            method: .get,
            queryParameters: queryParameters
        )
    }
    
    public func getSoundsCount() async throws -> Any {
        return try await fetchJSON(from: "\(api)/sounds/count")
    }

    
    public func getCountryList() async throws -> Any {
        return try await fetchJSON(from: "\(api)/trending/countries")
    }
    
    
    public func getLeaderboard(period: String) async throws -> Any {
        return try await fetchJSON(
            from: "\(api)/leaderboard/next-update-time",
            method: .get,
            queryParameters: ["period": period]
        )
    }
    
    public func getLeaderboardV2(period: String, metric: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "period": period,
            "metric": metric,
            "limit": "100"
        ]
        
        return try await fetchJSON(
            from: "\(api)/leaderboard/v2",
            method: .get,
            queryParameters: queryParameters
        )
    }

    
    public func getPlaylists(tab: String, sortBy: String, offset: Int) async throws -> Any {
        let queryParameters: [String: String] = [
            "tab": tab,
            "sort_by": sortBy,
            "offset": String(offset),
            "limit": "15"
        ]
        
        return try await fetchJSON(
            from: "\(api)/playlists",
            method: .get,
            queryParameters: queryParameters
        )
    }
    

    public func getUsers(offset: Int, sortBy: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "limit": "20",
            "offset": String(offset),
            "sort_by": sortBy
        ]
        
        return try await fetchJSON(
            from: "\(api)/users",
            method: .get,
            queryParameters: queryParameters
        )
    }
    

    public func search(query: String, offset: Int, sortBy: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "v3": "true",
            "query": query,
            "limit": "20",
            "offset": String(offset),
            "sort_by": sortBy
        ]
        
        return try await fetchJSON(
            from: "\(api)/search",
            method: .get,
            queryParameters: queryParameters
        )
    }

    
    public func searchMusic(offset: Int, sortBy: String, period: String, query: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "limit": "20",
            "offset": String(offset),
            "sort_by": sortBy,
            "period": period,
            "query": query
        ]
        
        return try await fetchJSON(
            from: "\(music_api)/music/",
            method: .get,
            queryParameters: queryParameters
        )
    }
    
    public func getMusic(offset: Int, sortBy: String, period: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "limit": "20",
            "offset": String(offset),
            "sort_by": sortBy,
            "period": period
        ]
        
        return try await fetchJSON(
            from: "\(music_api)/music",
            method: .get,
            queryParameters: queryParameters
        )
    }
    
    public func getMusicByGeo(offset: Int, sortBy: String, period: String, geo: String) async throws -> Any {
        let queryParameters: [String: String] = [
            "limit": "20",
            "offset": String(offset),
            "sort_by": sortBy,
            "period": period,
            "geo": geo
        ]
        
        return try await fetchJSON(
            from: "\(music_api)/music",
            method: .get,
            queryParameters: queryParameters
        )
    }
}
