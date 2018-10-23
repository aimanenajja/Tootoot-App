//
//  RideTableViewCell.swift
//  Tootoot
//
//  Created by Aïmane Najja on 23/10/2018.
//  Copyright © 2018 Aïmane Najja. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
