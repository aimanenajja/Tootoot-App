//
//  JoinRideViewController.swift
//  Tootoot
//
//  Created by Aïmane Najja on 23/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit
import os.log

class JoinRideTableViewController: UITableViewController {

    //MARK: Properties

    var rides = [Ride]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "Launchscreen"))
        self.title = "Join Ride"

        // Load the sample data.
        loadSampleRides()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RideTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RideTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RideTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let ride = rides[indexPath.row]

        //cell.distanceLabel.text = ride.distance //Dervis location impl
        cell.startTimeLabel.text = ride.startTime
        cell.destinationLabel.text = ride.destination
        cell.seatsLabel.text = ride.seats

        return cell
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let rideDetailViewController = segue.destination as? RideDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedRideCell = sender as? RideTableViewCell else {
            fatalError("Unexpected sender: \(sender)")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedRideCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedRide = rides[indexPath.row]
        rideDetailViewController.ride = selectedRide
    }

    //MARK: Private Methods
    private func loadSampleRides() {
        guard let ride1 = Ride(driver: "Emre", car: "Hyundai i30", beginLocation: "Mol", destination: "Hasselt", startTime: "07:00u", seats: "4") else {
            fatalError("Unable to instantiate ride1")
        }
        guard let ride2 = Ride(driver: "Burak", car: "Renault Clio", beginLocation: "Maasmechelen", destination: "Hasselt", startTime: "07:30u", seats: "4") else {
            fatalError("Unable to instantiate ride1")
        }
        guard let ride3 = Ride(driver: "Deniz", car: "BMW 118d", beginLocation: "Beringen", destination: "Hasselt", startTime: "07:30u", seats: "4") else {
            fatalError("Unable to instantiate ride1")
        }

        rides += [ride1, ride2, ride3]

    }

}
