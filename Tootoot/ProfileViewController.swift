//
//  ProfileViewController.swift
//  Tootoot
//
//  Created by dervis kiratli on 03/11/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var CurrentUserLabel: UILabel!
    
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
        self.imageView.layer.cornerRadius = self.imageView.frame.width/2.0
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
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
