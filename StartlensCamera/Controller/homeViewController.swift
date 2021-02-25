//
//  homeViewController.swift
//  StartlensCamera
//
//  Created by 中野　裕太 on 2021/02/24.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class homeViewController: UIViewController {

    @IBOutlet weak var noImageTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var token = String()
    var pagedExhibit: PagedExhibit?
    let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else{
            // if cannot get a token, move to login screen
            let logInViewController = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as! LogInViewController
            present(logInViewController, animated: true, completion: nil)
            return
        }
        self.token = savedToken
        setupUI()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PictureCell", bundle: nil), forCellReuseIdentifier: "PictureCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(homeViewController.update), for: .valueChanged)
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }
    
    @objc func update() {
        fetchData()
        tableView.reloadData()
        refresh.endRefreshing()
    }
    
    func setupUI() {
        print("noImageTitle".localized)
        noImageTitle.text = "noImageTitle".localized
    }
    
    func fetchData() {
        let url = Constants.baseURL + Constants.exhibitURL
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in

            switch response.result {
            case .success:
                self.pagedExhibit = try? JSONDecoder().decode(PagedExhibit.self, from: response.data!)
                
                if let num = self.pagedExhibit?.data.count, num != 0 {
                    self.noImageTitle.isHidden = true
                } else {
                    self.noImageTitle.isHidden = false
                }
                
            case .failure(let error):
                print(error)
            }
            self.tableView.reloadData()
        }
    }
}

extension homeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagedExhibit?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureCell
        let exhibit = pagedExhibit?.data[indexPath.row]

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.exhibitNameText.text = exhibit?.multiExhibits[0].name ?? "No name"
        cell.exhibitDescriptionText.text = exhibit?.multiExhibits[0].description ?? "No description"
        
        let pictureURL: URL?
        
        if let url = exhibit?.pictures[0].url {
            print("url: \(indexPath.row) \(url)")
            pictureURL = URL(string: url)
        } else {
            pictureURL = URL(fileURLWithPath: Bundle.main.path(forResource: "noimage", ofType: "png")!)
        }
        
        cell.exhibitImageView?.sd_setImage(with: pictureURL, completed: { (image, error, _, _) in
            if error == nil {
                cell.setNeedsLayout()
            }
        })
        return cell
    }
}

extension homeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped: \(indexPath)")
    }
}
