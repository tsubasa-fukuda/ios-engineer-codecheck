//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {

    @IBOutlet weak var avatarView: UIImageView!

    @IBOutlet weak var fullNameLbl: UILabel!

    @IBOutlet weak var languageLbl: UILabel!

    @IBOutlet weak var stargazersCountLbl: UILabel!
    @IBOutlet weak var watchersCountLbl: UILabel!
    @IBOutlet weak var forksCountLbl: UILabel!
    @IBOutlet weak var openIssuesCountLbl: UILabel!

    var repoSearchVC: RepoSearchViewController!

    let repositoryListModel = RepositoryListModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let index: Int = repoSearchVC.idx else { return }
        let repo = repoSearchVC.repositories[index]

        fullNameLbl.text = repo.fullName
        languageLbl.text = "Written in \(repo.language ?? "")"
        stargazersCountLbl.text = "\(repo.starCount ?? 0) stars"
        watchersCountLbl.text = "\(repo.watchersCount ?? 0) watchers"
        forksCountLbl.text = "\(repo.forksCount ?? 0) forks"
        openIssuesCountLbl.text = "\(repo.openIssuesCount ?? 0) open issues"
        repositoryListModel.avaterImageDelegate = self

        // アバター画像取得処理
        guard let avatarUrl = URL(string: repo.owner.avatarUrl) else { return }
        repositoryListModel.getAvaterImage(url: avatarUrl)

    }

}

// MARK: - アバター画像取得処理 -

extension RepoDetailViewController: AvaterImageDelegate {

    /// 検索結果を受信したらtableViewを更新する。
    /// - Parameter result: APIの取得結果（json辞書型）
    func fetchAvaterImage(result: ApiResult) {
        if result.type == .error {
            DispatchQueue.main.async {
                self.avatarView.image = nil
            }

            return
        }

        guard let avatarImg = result.value as? UIImage else { return }

        DispatchQueue.main.async {
            self.avatarView.image = avatarImg
        }
    }
}
