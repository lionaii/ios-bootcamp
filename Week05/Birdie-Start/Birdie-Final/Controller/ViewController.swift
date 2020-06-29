//
//  ViewController.swift
//  Birdie-Final
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        MediaPostsHandler.shared.getPosts()
        setUpTableView()
    }

    func setUpTableView() {
        let textPostCell = UINib(nibName: "TextPostCell", bundle: nil)
        let imagePostCell = UINib(nibName: "ImagePostCell", bundle: nil)
        tableview.dataSource = self
        tableview.delegate = self

        tableview.register(textPostCell, forCellReuseIdentifier: TextPostCell.identifier)
        tableview.register(imagePostCell, forCellReuseIdentifier: ImagePostCell.identifier)
    }

    @IBAction func didPressCreateTextPostButton(_ sender: Any) {
        let allertController = UIAlertController(title: "New Text Post", message: nil, preferredStyle: .alert)
        allertController.addTextField { (userNameField) in
          userNameField.placeholder = "User name"
          userNameField.autocapitalizationType = .words
        }
        allertController.addTextField { (bodyTextfield) in
          bodyTextfield.placeholder = "Enter post here"
        }
        
        allertController.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            let username = allertController.textFields?[0].text
            let text = allertController.textFields?[1].text
            MediaPostsHandler.shared.addTextPost(textPost: TextPost(textBody: text, userName: username!, timestamp: Date()))
            self.tableview.reloadData()
        })
        allertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(allertController, animated: true, completion: nil)
    }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {

    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MediaPostsHandler.shared.mediaPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = MediaPostsHandler.shared.mediaPosts[indexPath.row]
        guard (post is TextPost || post is ImagePost) else {
            return UITableViewCell()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
        
        if post is TextPost {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextPostCell.identifier, for: indexPath) as! TextPostCell
            cell.timeLabel.text = dateFormatter.string(from: post.timestamp)
            cell.usernameLabel.text = post.userName
            cell.textbodyLabel.text = post.textBody
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagePostCell.identifier, for: indexPath) as! ImagePostCell
            cell.timeLabel.text = dateFormatter.string(from: post.timestamp)
            cell.usernameLabel.text = post.userName
            cell.textbodyLabel.text = post.textBody
            if let imagePost = post as? ImagePost {
                cell.bodyImage.image = imagePost.image
            }
            return cell
        }
        
        
    }
    
}

