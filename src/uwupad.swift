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

public class Uwupad {
    private let api = "https://uwupad.me/api"
    private let music_api = "https://uwupad.me/music/api"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "Host":"uwupad.me",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }
    
    public func get_sounds(offset: Int,geo: String,sort_by: String) async throws -> Any {
        guard let url = URL(string: "\(api)/sounds/?beta=false&v3=true&tab=fyp&limit=15&offset=\(offset)&geo=\(geo)&content_langs=en%2Cru%2Csfx&sort_by=\(sort_by)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_sound_comments(id: Int,skip: Int,sort: String) async throws -> Any {
        guard let url = URL(string: "\(api)/sounds/\(id)/comments?skip=\(skip)&limit=10&sort=\(sort)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_sounds_count() async throws -> Any {
        guard let url = URL(string: "\(api)/sounds/count") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_country_list() async throws -> Any {
        guard let url = URL(string: "\(api)/trending/countries") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_leaderboard(period: String) async throws -> Any {
        guard let url = URL(string: "\(api)/leaderboard/next-update-time?period=\(period)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_leaderboard_v2(period: String,metric: String) async throws -> Any {
        guard let url = URL(string: "\(api)/leaderboard/v2?period=\(period)&metric=\(metric)&limit=100") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    
    public func get_playlists(tab: String, sort_by: String,offset: Int) async throws -> Any {
        guard let url = URL(string: "\(api)/playlists?tab=\(tab)&sort_by=\(sort_by)&offset=\(offset)&limit=15") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_users(offset: Int, sort_by: String) async throws -> Any {
        guard let url = URL(string: "\(api)/users?limit=20&offset=\(offset)&sort_by=\(sort_by)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func search(query: String,offset: Int, sort_by: String) async throws -> Any {
        guard let url = URL(string: "\(api)/search?v3=true&query=\(query)&limit=20&offset=\(offset)&sort_by=\(sort_by)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func search_music(offset: Int,sort_by: String,period: String,query: String) async throws -> Any {
        guard let url = URL(string: "\(music_api)/music/?limit=20&offset=\(offset)&sort_by=\(sort_by)&period=\(period)&query=\(query)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_music(offset: Int,sort_by: String,period: String) async throws -> Any {
        guard let url = URL(string: "\(music_api)/music?limit=20&offset=\(offset)&sort_by=\(sort_by)&period=\(period)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_music_by_geo(offset: Int,sort_by: String,period: String,geo: String) async throws -> Any {
        guard let url = URL(string: "\(music_api)/music?limit=20&offset=\(offset)&sort_by=\(sort_by)&period=\(period)&geo=\(geo)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
}
