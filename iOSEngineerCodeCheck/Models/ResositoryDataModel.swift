//
//  ResositoryDataModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Tsubasa Fukuda on 2022/05/05.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryListModelDelegate: AnyObject {
    func fetchRepositories(result: ApiResult)
}

/// リポジトリの検索を行うモデル
class RepositoryListModel: ApiTask {

    var task: URLSessionTask?
    weak var delegate: RepositoryListModelDelegate?

    func cancel() {
        if task?.state != URLSessionTask.State.running { return }
        task?.cancel()
        task = nil
    }

    /// 検索結果をViewControllerに送信する
    /// - Parameter serchRawWord: 検索ワード
    func getSearchResult(searchRawWord: String) {
        guard let apiUrl = Constraint.searchRepositoriesUrl(rawWord: searchRawWord) else { return }
        guard let function = delegate?.fetchRepositories else { return }
        cancel()
        task = URLSession.getApiResult(apiUrl: apiUrl, type: .json, completion: function)
    }
}

struct GitHubSearchResult: Codable {
    let items: [GitHubRepository]?
}

struct GitHubRepository: Codable {

    let id: Int
    let name: String
    let fullName: String
    let language: String?
    let starCount: Int?
    let watchersCount: Int?
    let forksCount: Int?
    let openIssuesCount: Int?
    let owner: GitHubOwner

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fullName = "full_name"
        case language = "language"
        case starCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner = "owner"
    }

}

struct GitHubOwner: Codable {

    let id: Int
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case avatarUrl = "avatar_url"
    }

}
