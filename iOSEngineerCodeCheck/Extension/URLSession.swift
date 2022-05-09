//
//  URLSession.swift
//  iOSEngineerCodeCheck
//
//  Created by Tsubasa Fukuda on 2022/05/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

extension URLSession {

    /// API結果取得処理
    /// - Parameters:
    ///   - apiUrl: 検索URL
    ///   - type: 取得するデータ型
    ///   - completion: delegateで実行するfunction
    class func getApiResult(apiUrl: URL,
                            type: ApiResultType,
                            completion: @escaping (ApiResult) -> Void) -> URLSessionTask? {

        let task = self.shared.dataTask(with: apiUrl) {(data, _, err) in
            if let err = err {
                print("session_error: \(err)")
                completion(ApiResult(type: .error, data: nil))
                return
            }
            guard let data = data else {
                print("data = nil")
                completion(ApiResult(type: .error, data: nil))
                return
            }
            completion(ApiResult(type: type, data: data))
        }

        task.resume()
        return task
    }

    class func getAvaterImage(url: URL,
                              type: ApiResultType,
                              completion: @escaping (ApiResult) -> Void) -> URLSessionTask? {

        let task = self.shared.dataTask(with: url) {(data, _, err) in
            if let err = err {
                print("session_error: \(err)")
                completion(ApiResult(type: .error, data: nil))
                return
            }
            guard let data = data else {
                print("data = nil")
                completion(ApiResult(type: .error, data: nil))
                return
            }
            completion(ApiResult(type: type, data: data))
        }

        task.resume()
        return task
    }
}

protocol ApiTask {
    func cancel()
    func getSearchResult(searchRawWord: String)
    func getAvaterImage(url: URL)
}

/// Apiの結果と型を保持する構造体
struct ApiResult {
    let type: ApiResultType
    private let data: Data?

    var value: Any? {
        switch self.type {
        case .json:
            guard let data = self.data else { return nil }
            do {
                return try JSONDecoder().decode(GitHubSearchResult.self, from: data)
            } catch { return nil }
        case .image:
            guard let data = self.data else { return nil }
            return UIImage(data: data) ?? nil
        default:
            return [String: Any]()
        }
    }

    init(type: ApiResultType, data: Data?) {
        self.type = type
        self.data = data
    }
}

enum ApiResultType {
    case error
    case json
    case image
}
