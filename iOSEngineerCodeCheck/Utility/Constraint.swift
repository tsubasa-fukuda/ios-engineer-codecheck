//
//  Constraint.swift
//  iOSEngineerCodeCheck
//
//  Created by Tsubasa Fukuda on 2022/05/05.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

class Constraint {

    public static let gitHubApiDomainURL: URL = URL(string: "https://api.github.com")!

    /// 検索用URLを作成
    /// - Parameter rawWord: 検索ワード
    /// - Returns: 検索URL。パーセントエンコーディングに失敗した場合、nilを返す
    public static func searchRepositoriesUrl(rawWord: String) -> URL? {

        guard let query = rawWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        let urlString = gitHubApiDomainURL.absoluteString + "/search/repositories?q=\(query)"

        return URL(string: urlString)

    }
}
