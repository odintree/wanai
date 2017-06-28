//
//  HomeViewController.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 28/06/17.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeTableView: UITableView!
    var ref : DatabaseReference!
    var posts = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        getPostsFromServer()
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    func getPostsFromServer() {
        self.ref?.child("posts").queryOrdered(byChild: "timestamp").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.posts.removeAll()
                
                for posts in snapshot.children.allObjects as! [DataSnapshot] {
                    let postObject = posts.value as! [String : AnyObject]
                    let post = self.createPost(postObject: postObject)
                    
                    self.posts.append(post)
                }
                print(self.posts)
                self.homeTableView.reloadData()
            }
        })
    }
    
    func createPost(postObject: [String: AnyObject]) -> PostModel {
        let id = postObject["id"]
        let email = postObject["email"]
        let image = postObject["image"]
        let storageUUID = postObject["storageUUID"]
        let timestamp = postObject["timestamp"]
        let userUid = postObject["userUid"]
        return PostModel(id: id as? String, image: image as? String, email: email as? String, storageUUID: storageUUID as? String, timestamp: timestamp as? String, userUid: userUid as? String)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        
        let post : PostModel
        post = posts[indexPath.row]
        
        cell.displayName.text = post.email
        cell.homeCellImage.sd_setImage(with: URL(string: post.image!))
        
        return cell
    }

}
