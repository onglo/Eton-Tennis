//
//  gameScore.swift
//  Eton Tennis
//
//  Created by Edouard Long on 21/11/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GameScore: Player {
    
    // save number of games that they have
    var numberOfGames = 0
    
    // init data type
    func setNumberOfGames(snapshot: DataSnapshot) {
        
        // get snapshot value as dict
        let snapshotValue = snapshot.value as! [String: AnyObject]
                
        // same game score
        numberOfGames = snapshotValue["games"] as! Int;
    }
    
}
