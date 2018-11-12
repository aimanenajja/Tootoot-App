//
//  ProfileViewController.swift
//  Tootoot
//
//  Created by dervis kiratli on 03/11/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase
import os.log

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var CurrentUserLabel: UILabel!
    
    var profile: Profile? = nil
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            
            self.CurrentUserLabel.text = username
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.imageView.layer.masksToBounds = true
        if UIDevice.current.orientation.isLandscape {
            self.imageView.layer.cornerRadius = self.imageView.frame.width
            self.CurrentUserLabel.font = self.CurrentUserLabel.font.withSize(self.CurrentUserLabel.font.pointSize*2)
        } else {
            self.imageView.layer.cornerRadius = self.imageView.frame.width/2.0
        }
        
        // Load any saved meals, otherwise load sample data.
        if let savedProfile = loadProfile() {
            profile = savedProfile
        } else {
            profile = Profile.init(name: CurrentUserLabel.text ?? "", photo: UIImage(named: "defaultPhoto"))
        }
        
        if let profile = profile {
            CurrentUserLabel.text = profile.name
            imageView.image = profile.photo
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            
            self.CurrentUserLabel.frame.size.height = self.CurrentUserLabel.frame.height * 2
            print(self.CurrentUserLabel.frame.height)
            self.CurrentUserLabel.font = self.CurrentUserLabel.font.withSize(self.CurrentUserLabel.font.pointSize*2)
            self.imageView.layer.cornerRadius = self.imageView.frame.width
        } else {
            print("Portrait")
            self.CurrentUserLabel.frame.size.height = self.CurrentUserLabel.frame.height / 2
            
            print(self.CurrentUserLabel.frame.height)
            self.CurrentUserLabel.font = self.CurrentUserLabel.font.withSize(self.CurrentUserLabel.font.pointSize/2)
            self.imageView.layer.cornerRadius = self.imageView.frame.width/4.0
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func selectPhoto(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        profile?.photo = image
        
        picker.dismiss(animated: true, completion: nil)
        saveProfile()
    }
    
    private func saveProfile() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(profile!, toFile: Profile.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadProfile() -> Profile?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Profile.ArchiveURL.path) as? Profile
    }
    
}
