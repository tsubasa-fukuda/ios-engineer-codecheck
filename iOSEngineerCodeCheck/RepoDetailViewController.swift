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

    var vc1: RepoSearchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let repo = vc1.repos[vc1.idx]

        languageLbl.text = "Written in \(repo["language"] as? String ?? "")"
        stargazersCountLbl.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersCountLbl.text = "\(repo["watchers_count"] as? Int ?? 0) watchers"
        forksCountLbl.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        openIssuesCountLbl.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()

    }

    func getImage() {

        let repo = vc1.repos[vc1.idx]

        fullNameLbl.text = repo["full_name"] as? String

        if let owner = repo["owner"] as? [String: Any] {
            if let avatarImgUrl = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: avatarImgUrl)!) { [weak self] (data, _, _) in
                    guard let self = self else { return }
                    let avatarImg = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.avatarView.image = avatarImg
                    }
                }.resume()
            }
        }

    }

}
