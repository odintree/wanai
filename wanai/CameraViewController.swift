//
//  CameraViewController.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 27/06/17.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var uploadPicture: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func pictureButtonClicked(_ sender: UIButton) {
        print("picture")
    }

    @IBAction func uploadButtonClicked(_ sender: UIButton) {
        print("upload")
    }
}
