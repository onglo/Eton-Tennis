//
//  matchDataFormat.swift
//  Eton Tennis
//
//  Created by Edouard Long on 23/10/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import Foundation
import FirebaseDatabase
struct game {
    
    // init player vars
    var playerA:String
    var playerASchool:String
    var playerB:String
    var playerBSchool:String
    
    // init score
    var score = [String]()
    
    // init completed
    var completed:Bool
    
    // init match code
    var matchCode:String
    
    // init number of sets
    var numberOfSets:Int
    
    // init court no.
    var courtNumber:String
    
    // func to turn data to any object
    func toAnyObject() -> Any {
        return [
            "playerA":playerA,
            "playerASchool":playerASchool,
            "playerB":playerB,
            "playerBSchool":playerBSchool,
            "score":score,
            "completed":completed,
            "matchCode":matchCode,
            "numberOfSets":numberOfSets,
            "courtNumber":courtNumber
        ]
    }
    
    // init from a snapshot
    init(snapshot:DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        //name = snapshotValue["name"] as! String
        // set values
        playerA = snapshotValue["playerA"] as! String
        playerB = snapshotValue["playerB"] as! String
        playerASchool = snapshotValue["playerASchool"] as! String
        playerBSchool = snapshotValue["playerBSchool"] as! String
        score = snapshotValue["score"] as! [String]
        completed = snapshotValue["completed"] as! Bool
        matchCode = snapshotValue["matchCode"] as! String
        numberOfSets = snapshotValue["numberOfSets"] as! Int
        courtNumber = snapshotValue["courtNumber"] as! String
    }
    
    // init from values
    init(playerAParameter: String, playerASchoolParameter: String, playerBParameter: String, playerBSchoolParameter: String, scoreParameter: [String], completedParameter: Bool, matchCodeParameter: String, numberOfSetsParameter: Int, courtNumberParameter: String) {
        
        // set values
        playerA = playerAParameter
        playerB = playerBParameter
        playerASchool = playerASchoolParameter
        playerBSchool = playerBSchoolParameter
        score = scoreParameter
        completed = completedParameter
        matchCode = matchCodeParameter
        numberOfSets = numberOfSetsParameter
        courtNumber = courtNumberParameter
        
    }
}
