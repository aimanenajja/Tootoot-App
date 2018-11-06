//
//  RideDetailViewController.swift
//  Tootoot
//
//  Created by Aïmane Najja on 27/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class RideDetailViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate {

    //MARK: Properties
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var remainingSeatsLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var yourDestinationTextField: UITextField!
    
    var ref: DatabaseReference!
    var ride: Ride?
    var driverId: String = ""
    var username: String = ""
    let locationManager = CLLocationManager()
    var locLat : Double = 0
    var locLong : Double = 0
    var location = CLLocation(latitude: 0, longitude: 0)
    var address: String = ""
    lazy var geocoder = CLGeocoder()
    var uid : String = ""
    var distance : Double = 0
    var confirmed : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Set up views if editing an existing Meal.
        if let ride = ride {
            driverLabel.text = ride.driver
            carLabel.text = ride.car
            beginLocationLabel.text = ride.beginLocation
            endLocationLabel.text = ride.destination
            startTimeLabel.text = ride.startTime
            remainingSeatsLabel.text = ride.seats
            commentsTextView.text = ride.comments
        }
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
            print("locations = \(locLong) \(locLat)")
            let coordinatePassenger = CLLocation(latitude: locLat, longitude: locLong)
            ref.child("rides").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    print("SNAPSHOT: \(snapshot)")
                    
                    for snap in snapshot {
                        if let userDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            if userDict["driver"] as? String == self.driverLabel.text {
                                print(snap.childSnapshot(forPath: "latitude").value)
                                print("teeeeest")
                                let driverLat = snap.childSnapshot(forPath: "latitude").value
                                
                                let driverLong = snap.childSnapshot(forPath: "longitude").value
                                
                                let coordinateDriver = CLLocation(latitude: driverLat as! CLLocationDegrees, longitude: driverLong as! CLLocationDegrees)
                                self.distance = coordinatePassenger.distance(from: coordinateDriver)
                                
                            }
                        }
                    }
                    
                    
                }
                
                
            })
            print(distance)
            
        }
        
        //Get current username
        if let user = Auth.auth().currentUser {
            uid = user.uid
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                print(value!)
                print("Passengers/" + self.uid)
                self.username = value?["username"] as? String ?? ""
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        //check for deletion
        
        
        self.title = "Ride Details"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SendJoinRequestButton(_ sender: UIButton) {
        
        // Voeg Passenger toe aan lijst van Ride
        ref.child("rides").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                print("SNAPSHOT: \(snapshot)")
                
                for snap in snapshot {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if userDict["driver"] as? String == self.driverLabel.text {
                            self.driverId = snap.key
                            print(self.driverId)
                                                      //Add this key to userID array
                            
                            let name = self.username
                            let location = self.address
                            let destination = self.yourDestinationTextField.text
                            self.ref.child("rides").child(self.driverId).child("passengers").child(self.uid).setValue(["name": name, "location": location, "destination": destination!])
                            
                            
                            self.notifyUser(_driverID: self.driverId)
                                break
                            
                            
                        }
                    }
                }
                
                
            }
            
            
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locLong = locValue.longitude
        locLat = locValue.latitude
        location = CLLocation(latitude: locLat, longitude: locLong)
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            address = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                address = placemark.compactAddress ?? "default value"
            } else {
                address = "No Matching Addresses Found"
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        yourDestinationTextField.resignFirstResponder()
    }
    
    func notifyUser(_driverID : String){
        
        ref.child("rides").child(_driverID).observe(DataEventType.value) { (snapshot) in
            print(snapshot)
            if snapshot.hasChild("passengers")
            {
                print("test")
                if !snapshot.hasChild("passengers/" + self.uid)
                {
                    print("Test2")
                    let alert = UIAlertController(title: "Denied!", message: "You got denied by the driver", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            } else
            {
                print("Er zijn geen passengers")
                let alert = UIAlertController(title: "Denied!", message: "You got denied by the driver", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        ref.child("confirmed").child(_driverID).observe(DataEventType.value){ (snapshot) in
            print(snapshot)
            if (snapshot.value as? String == "true") {
                let alert = UIAlertController(title: "Accepted!", message: "You got accepted by the driver", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "confirmed", sender: nil)
                    }))
                self.present(alert, animated: true)
            }
        }
    }
}
