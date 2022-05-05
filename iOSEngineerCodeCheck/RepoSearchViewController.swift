//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepoSearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var repos: [[String: Any]]=[]

    var task: URLSessionTask?
    var searchWord: String?
    var repoUrl: String?
    var idx: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.searchWord = searchBar.text ?? ""
        guard let query = self.searchWord?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }

        if query.count != 0 {
            self.repoUrl = "https://api.github.com/search/repositories?q=\(query)"
            guard let repoUrl = self.repoUrl else { return }

            self.task = URLSession.shared.dataTask(with: URL(string: repoUrl)!) { [weak self] (data, _, _) in
                guard let self = self else { return }
                do {
                    if let obj = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                        if let items = obj["items"] as? [[String: Any]] {
                        self.repos = items
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                } catch {
                    // 例外処理
                }
            }
        // これ呼ばなきゃリストが更新されません
        task?.resume()
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Detail"{
            if let dtl = segue.destination as? RepoDetailViewController {
                dtl.repoSearchVC = self
            }
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let repo = self.repos[indexPath.row]
        cell.textLabel?.text = repo["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repo["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)

    }

}
