//
//  matchTableViewCell.swift
//  Eton Tennis
//
//  Created by Edouard Long on 26/10/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import UIKit

class matchTableViewCell: UITableViewCell {

    // link table cell elements
    @IBOutlet weak var courtAndProgressLabel: UILabel!
    @IBOutlet weak var playerALabel: UILabel!
    @IBOutlet weak var playerBLabel: UILabel!
    @IBOutlet weak var playerAScoreLabel: UILabel!
    @IBOutlet weak var playerBScoreLabel: UILabel!
    
    // init vars we can use to store all of the data
    var courtNumber:String!
    var matchCode:String!
    var playerAName:String!
    var playerASchool:String!
    var playerBName:String!
    var playerBSchool:String!
    var completed:Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
