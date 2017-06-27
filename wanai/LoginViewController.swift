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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }


}
