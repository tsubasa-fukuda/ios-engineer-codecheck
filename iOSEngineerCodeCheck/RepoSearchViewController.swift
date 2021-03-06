//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepoSearchViewController: UITableViewController, UISearchBarDelegate {

    var repositories: [GitHubRepository]=[]
    let repositoryListModel = RepositoryListModel()

    @IBOutlet weak var searchBar: UISearchBar!

    var searchWord: String?
    var repoUrl: String?
    var idx: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        repositoryListModel.repositoryListModelDelegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchWord = searchBar.text else { return }
        self.view.endEditing(true)
        repositoryListModel.getSearchResult(searchRawWord: searchWord)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Detail"{
            if let dtl = segue.destination as? RepoDetailViewController {
                dtl.repoSearchVC = self
            }
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let repo = self.repositories[indexPath.row]
        cell.textLabel?.text = repo.fullName
        cell.detailTextLabel?.text = repo.language ?? ""
        cell.tag = indexPath.row
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)

    }

}

// MARK: - tableView更新処理 -

extension RepoSearchViewController: RepositoryListModelDelegate {

    /// 検索結果を受信したらtableViewを更新する。
    /// - Parameter result: APIの取得結果（json辞書型）
    func fetchRepositories(result: ApiResult) {
        if result.type == .error {
            self.repositories = [GitHubRepository]()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            return
        }
        guard let repositoryData = result.value as? GitHubSearchResult else { return }
        guard let items = repositoryData.items else { return }
        self.repositories = items

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
