//
//  SecondViewController.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 27/06/17.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class FollowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FollowTableViewCellDelegate {

    var users = [User]()
    var db: DatabaseReference!
    var filteredData = [User]()
    
    @IBOutlet weak var followTableView: UITableView!
    @IBOutlet weak var searchInput: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Database.database().reference()
        
        followTableView.dataSource = self
        followTableView.delegate = self
        
        retrieveUsers()
    }
    
    func retrieveUsers() {
        db.child("users").queryOrderedByKey().observe(.value, with: { snapshot in
            if let dbUsers = snapshot.value as? [String: [String: String]],
                let userId = Auth.auth().currentUser?.uid {
                
                print("Logged user "+userId)
                
                self.db.child("follows").queryOrderedByKey().queryEqual(toValue: userId).observe(.value, with: { snapshot in
                    
                    self.users.removeAll()
                    for eachUser in dbUsers {
                        if (eachUser.key != userId) {
                            print("Listed user " + eachUser.key)
                            let user = User()
                            user.uid = eachUser.key
                            user.username = eachUser.value["name"]
                            
                            for case let childSnapshot as DataSnapshot in snapshot.children {
                                print("Child: ")
                                print(childSnapshot)
                                if childSnapshot.key == userId {
                                    print("Child Value: ")
                                    print(childSnapshot.value!)
                                    if let following = childSnapshot.value as? [String: [String: String]]{
                                        print(following)
                                        if  (following[eachUser.key] != nil) {
                                            user.follow = true
                                        }
                                    }
                                }
                            }
                            self.users.append(user)
                        }
                    }
                    self.followTableView.reloadData()
                })
            }
        })
        
    }


    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
        
        FBSDKLoginManager().logOut()
        
        UserDefaults.standard.removeObject(forKey: "userSigned")
        UserDefaults.standard.synchronize()
        
        let signUp = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = signUp
        delegate.rememberLogin()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowCell") as! FollowTableViewCell
        
        let user = users[indexPath.row]
        
        cell.usernameText.text = user.username
        cell.selectionStyle = .none
        cell.delegate = self
        if user.follow {
            cell.followButton.setTitle("Unfollow", for: .normal)
        } else {
            cell.followButton.setTitle("Follow", for: .normal)
        }
        
        return cell
    }
    
    func followCellFollowButtonPressed(sender: FollowTableViewCell) {
        if let indexPath = followTableView.indexPath(for: sender) {
            let user = users[indexPath.row]
            user.follow = !user.follow
            if let userId = Auth.auth().currentUser?.uid,
                let followedUser = user.uid {
                
                if user.follow == true {
                    let followItem = ["uid": user.uid!]
                    
                    let childUpdates = ["/follows/\(userId)/\(followedUser)": followItem,
                                        "/followedBy/\(followedUser)/\(userId)/": ["uid": userId]] as [String : Any]
                    self.db.updateChildValues(childUpdates)
                    
                } else {
                    self.db.child("follows").child(userId).child(followedUser).removeValue()
                    self.db.child("followedBy").child(followedUser).child(userId).removeValue()
                    
                }
            }
            followTableView.reloadData()
            
        }
    }
    
    


}

