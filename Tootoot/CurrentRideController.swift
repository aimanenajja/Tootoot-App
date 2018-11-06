//
//  CurrentRideController.swift
//  Tootoot
//
//  Created by dervis kiratli on 22/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import Firebase

class CurrentRideController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var passengersTableView: UITableView!
    
    var ref: DatabaseReference!
    var refPassagiers: DatabaseReference!
    var passengers = [Passenger]()
    var passengerId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        passengersTableView.delegate = self
        passengersTableView.dataSource = self
        
        ref = Database.database().reference()
        
        // om de destination mee te geven, kan eenvoudiger normaal
        let userID = Auth.auth().currentUser?.uid
        ref.child("rides").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print(value!)
            let destination = value?["endLocation"] as? String ?? ""
            
            self.destination.text = "Destination: " + destination
        }) { (error) in
            print(error.localizedDescription)
        }
        // om de tabel van passagiers te vullen
        
        refPassagiers = Database.database().reference().child("rides").child(userID!).child("passengers");
        
        refPassagiers.observe(DataEventType.value, with: { (snapshot) in
            print(snapshot)
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.passengers.removeAll()
                
                //iterating through all the values
                for passengers in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    
                    if (passengers.value as? [String: AnyObject]) != nil {
                        let passengerObject = passengers.value as? [String: AnyObject]
                        let passengerName = passengerObject?["name"]
                        let passengerLocation = passengerObject?["location"]
                        let passengerDestination = passengerObject?["destination"]
                        
                        let passenger = Passenger(name: passengerName as! String, location: passengerLocation as! String, destination: passengerDestination as! String)
                        
                        //appending it to list
                        self.passengers.append(passenger!)
                    }
                    
                }
                
                //reloading the tableview
                self.passengersTableView.reloadData()
            }
        })
        
        self.title = "Current Ride"

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PassengerTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PassengerTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PassengerTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let passenger = passengers[indexPath.row]
        
        //cell.distanceLabel.text = ride.distance //Dervis location impl
        cell.passengerNameLabel.text = passenger.name
        cell.passengerLocationLabel.text = passenger.location
        cell.passengerDestinationLabel.text = passenger.destination
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Fetches the appropriate meal for the data source layout.
            let passenger = passengers[indexPath.row]
            print(passenger.name)
            
            passengers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            refPassagiers.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    print("SNAPSHOT: \(snapshot)")
                    
                    for snap in snapshot {
                        if let userDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            if userDict["name"] as? String == passenger.name {
                                self.passengerId = snap.key
                                print(self.passengerId)
                                
                                self.refPassagiers.child(self.passengerId).removeValue()
                                break
                            }
                        }
                    }
                    self.passengersTableView.reloadData()
                }
            })
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func finishRide(_ sender: UIButton) {
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("rides").child(userID!).removeValue()
        
    }
    
    
}
