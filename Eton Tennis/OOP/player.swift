//
//  player.swift
//  Eton Tennis
//
//  Created by Edouard Long on 21/11/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Player {
    
    // init player name
    var playerName = ""
    
    // init func to read player name
    init(snapshot:DataSnapshot) {
        
        // get snapshot value as dict
        let snapshotValue = snapshot.value as! [String: AnyObject]

        // save player name
        playerName = snapshotValue["name"] as! String;
    }
}
