//
//  LoginViewController.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 27/06/17.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var facebooklogin: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = Database.database().reference()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if username.text != "" && password.text != "" {
            Auth.auth().signIn(withEmail: username.text!, password: password.text!, completion: { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    UserDefaults.standard.set(user!.uid, forKey: "userSigned")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
                }
            })
        }
    }
    
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        if username.text != "" && password.text != "" {
            Auth.auth().createUser(withEmail: username.text!, password: password.text!, completion: { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    UserDefaults.standard.set(user!.uid, forKey: "userSigned")
                    UserDefaults.standard.synchronize()
                    
                    if let uid = Auth.auth().currentUser?.uid as String! {
                        
                        self.ref.child("users").child(uid).setValue(["name": user?.email!])
                        
                        let followItem = ["uid": uid]
                        let childUpdates = ["/follows/\(uid)/\(uid)": followItem,
                                            "/followedBy/\(uid)/\(uid)/": followItem] as [String : Any]
                        self.ref.updateChildValues(childUpdates)
                    }
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
                }
            })
            
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Provide your E-mail and password.", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func facebookButtonClicked(_ sender: UIButton) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if (error != nil || (result?.isCancelled)!) {
                let alert = UIAlertController(title: "Error", message: "Provide your E-mail and password.", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: (result?.token.tokenString)!)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if (error != nil) {
                        let alert = UIAlertController(title: "Error", message: "Provide your E-mail and password.", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    UserDefaults.standard.set(user!.uid, forKey: "userSigned")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
                }
            }
        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil) {
                if let uid = user?.uid as String! {
                    print(uid)
                    if let providerData = user?.providerData {
                        for profile in providerData {
                            //print("Sign-in provider: " 	+ profile.providerId)
                            print("  Provider-specific UID: "+profile.uid)
                            var displayName: String
                            if profile.displayName != nil {
                                displayName = profile.displayName!
                            } else {
                                displayName = profile.email!
                            }
                            
                            print("  Name: "+displayName)
                            print("  Email: "+profile.email!)
                            //print("  Photo URL: "profile.photoURL)
                        }
                    }
                    
                    let followItem = ["uid": uid]
                    let childUpdates = ["/follows/\(uid)/\(uid)": followItem,
                                        "/followedBy/\(uid)/\(uid)/": followItem] as [String : Any]
                    self.ref.updateChildValues(childUpdates)
                }
            }
        }
    }


}
