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
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    


}

