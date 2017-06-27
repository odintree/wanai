//
//  CameraViewController.swift
//  wanai
//
//  Created by Vítor Vazquez Miguel on 27/06/17.
//  Copyright © 2017 BTS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import AVFoundation
import Photos

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadPicture: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    var uuid = NSUUID().uuidString
    var refPosts : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refPosts = Database.database().reference().child("posts")
    }

    @IBAction func pictureButtonClicked(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { (action) in
                
                let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                
                if (status == .authorized) {
                    self.displayPicker(type: .camera)
                }
                if (status == .restricted) {
                    self.handleRestricted()
                }
                if (status == .denied) {
                    self.handleDenied()
                }
                if (status == .notDetermined) {
                    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                        if (granted) {
                            self.displayPicker(type: .camera)
                        }
                    })
                }
            }
            alertController.addAction(cameraAction)
        }
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            let cameraRollAction = UIAlertAction(title: "Use Camera Roll", style: .default) { (action) in
                
                let status = PHPhotoLibrary.authorizationStatus()
                
                if (status == .authorized) {
                    self.displayPicker(type: .photoLibrary)
                }
                if (status == .restricted) {
                    self.handleRestricted()
                }
                if (status == .denied) {
                    self.handleDenied()
                }
                if (status == .notDetermined) {
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if (status == PHAuthorizationStatus.authorized) {
                            self.displayPicker(type: .photoLibrary)
                        }
                    })
                }
            }
            alertController.addAction(cameraRollAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func displayPicker(type: UIImagePickerControllerSourceType) {
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: type)!
        self.imagePicker.sourceType = type
        self.imagePicker.allowsEditing = true
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func handleRestricted() {
        let alertController = UIAlertController(title: "Media Access Denied", message: "This device is restricted from access to media in your phone", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func handleDenied() {
        let alertController = UIAlertController(title: "Media Access Denied", message: "This device is restricted from access to media in your phone. Please update your settings", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
            DispatchQueue.main.async {
                UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        uploadPicture.contentMode = .scaleAspectFill
        uploadPicture.image = chosenImage
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadButtonClicked(_ sender: UIButton) {
        self.uploadButton.isEnabled = false
        
        let mediaFolder = Storage.storage().reference().child("media")
        
        if let photo = UIImageJPEGRepresentation(uploadPicture.image!, 0.5) {
            mediaFolder.child("\(uuid).jpg").putData(photo, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    let uid = Auth.auth().currentUser?.uid
                    let key = self.refPosts.childByAutoId().key
                    
                    let photoPost = ["id" : key,"image" : imageURL!, "userUid" : uid!, "storageUUID": self.uuid, "timestamp": ServerValue.timestamp()] as [String : Any]
                    
                    self.refPosts.child(key).setValue(photoPost)
                    
                    self.uploadPicture.image = UIImage(named: "")
                    self.uploadButton.isEnabled = false
                    self.tabBarController?.selectedIndex = 0
                    
                }
            })
        }
    }
}
