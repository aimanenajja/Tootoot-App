//
//  JoinRideViewController.swift
//  Tootoot
//
//  Created by Aïmane Najja on 23/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit

class JoinRideTableViewController: UITableViewController {

    //MARK: Properties
    
    var rides = [Ride]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        cell.distanceLabel.text = ride.distance
        cell.startTimeLabel.text = ride.startTime
        cell.destinationLabel.text = ride.destination
        cell.seatsLabel.text = ride.seats
        
        return cell
    }
    
    //MARK: Private Methods
    private func loadSampleRides() {
        guard let ride1 = Ride(distance: "1,9 km", startTime: "07:30u", destination: "Hasselt", seats: "4") else {
            fatalError("Unable to instantiate ride1")
        }
        guard let ride2 = Ride(distance: "2,6 km", startTime: "04:30u", destination: "Diepenbeek", seats: "4") else {
            fatalError("Unable to instantiate ride1")
        }
        guard let ride3 = Ride(distance: "5,5 km", startTime: "08:30u", destination: "Leuven", seats: "4") else {
            fatalError("Unable to instantiate ride1")
        }
        
        rides += [ride1, ride2, ride3]
        
    }

}
