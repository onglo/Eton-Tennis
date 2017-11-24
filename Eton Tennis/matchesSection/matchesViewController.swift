//
//  matchesViewController.swift
//  Eton Tennis
//
//  Created by Edouard Long on 23/10/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class matchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    // init did change state auth handle
    var handle:AuthStateDidChangeListenerHandle!
    
    // init db ref
    var dbRef:DatabaseReference!
    
    // init child changed listener
    var childChangedListener:DatabaseHandle!
    
    // init tapped cell ref
    var tappedCellRef:DatabaseHandle!
    
    // link table view
    @IBOutlet weak var tableView: UITableView!
    
    // init table data var
    var tableData = [game]()
    
    // init data var
    var data:stateType = .loading
    
    // init segue data
    var segueData = Array<Any>()
    
    // init currentMatchCode
    var currentMatchCode = "deafult"
    
    // data type format to keep track of which state we are in
    enum stateType {
        case deafult, loading, nogames
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        
//        if (data == "loading" || data == "No games to show") {
//            return 1
//        }
//        else {
//            return tableData.count
//        }
        
        switch data {
        case .deafult:
            return tableData.count
        case .loading:
            return 1
        case .nogames:
            return 1
        }
        
    }
    
    // set height of section
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    // make section split transparent
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // create a new view
        let transparentView = UIView()
        
        // make it transparent
        transparentView.backgroundColor = UIColor.clear
        
        return transparentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // init cell
        var noDataCell:noDataTableViewCell!
        var matchesCell:matchTableViewCell!
        
        // check if loading or no data
        if (data == .loading || data == .nogames) {
            
            // get cell from board
            noDataCell = tableView.dequeueReusableCell(withIdentifier: "emptyTable") as! noDataTableViewCell
            
            // change text of label
            //noDataCell.infoTextLabel.text = data.capitalized
            
            // check what we need the label to display
            if data == .loading {
                // change text of label
                noDataCell.infoTextLabel.text = "Loading..."
            }
            else {
                // change text to no games to show
                noDataCell.infoTextLabel.text = "No games to show"
            }
            
            return noDataCell
        
        }
        else {
            
            // get cell from board
            matchesCell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as! matchTableViewCell
            
            // check if in progresss is true
            var inProgress = "In Progress"
            if tableData[indexPath.section].completed == true {
                inProgress = "Completed"
            }
            
            // set info we need
            // set court and progress
            matchesCell.courtAndProgressLabel.text = "Court \(tableData[indexPath.section].courtNumber) - \(inProgress)"
            
            // set player a label
            matchesCell.playerALabel.text = "\(tableData[indexPath.section].playerA) (\(tableData[indexPath.section].playerASchool))"
            
            // set player b label
            matchesCell.playerBLabel.text = "\(tableData[indexPath.section].playerB) (\(tableData[indexPath.section].playerBSchool))"
            
            // check how many sets we have compared to number of total sets of game
            let missingSets = tableData[indexPath.section].numberOfSets - tableData[indexPath.section].score.count
            
            // init temp score array
            var scorePlaceholder = tableData[indexPath.section].score
            
            // check if we need extra sets
            if missingSets > 0 {
                // for each missing game add this to the game placeholder
                for _ in 0...missingSets - 1 {
                    
                    // add an extra empty set
                    scorePlaceholder.append("0-0")
                }
            }
            
            // loop through each game
            var playerAScore = ""
            var playerBScore = ""
            
            for game in scorePlaceholder {
                
                // split score into player a and b
                let split = game.split(separator: "-")
                playerAScore.append("\(split[0]) ")
                playerBScore.append("\(split[1]) ")
                
            }

            
            // reverse the labels so they display the games in the right data
            playerAScore = String(playerAScore.reversed())
            playerBScore = String(playerBScore.reversed())
            
            // remove white space from beginning of string
            playerAScore = String(playerAScore.suffix(playerAScore.count - 1))
            playerBScore = String(playerBScore.suffix(playerBScore.count - 1))
            
            // set score labels
            matchesCell.playerAScoreLabel.text = playerAScore
            matchesCell.playerBScoreLabel.text = playerBScore
            
            // set vars we want
            matchesCell.courtNumber = tableData[indexPath.section].courtNumber
            matchesCell.playerAName = tableData[indexPath.section].playerA
            matchesCell.playerASchool = tableData[indexPath.section].playerASchool
            matchesCell.playerBName = tableData[indexPath.section].playerB
            matchesCell.playerBSchool = tableData[indexPath.section].playerBSchool
            matchesCell.completed = tableData[indexPath.section].completed
            matchesCell.matchCode = tableData[indexPath.section].matchCode

            return matchesCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // executed when the table view is scrolled
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // check if the user wants to add a new event
        if (tableView.contentOffset.y < -50) {
            
            // go to create new match page
            self.performSegue(withIdentifier: "createNewMatchSegue", sender: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set tableview data source
        tableView.dataSource = self
        tableView.delegate = self
        
        // set height of cells
        self.tableView.rowHeight = 80.0
        
        // set db ref
        dbRef = Database.database().reference()
        
        // listen for when matches are added
        dbRef.child("matches").observe(.childAdded) { (snapshot) in

            // convert data to redable format
            let gameData:game = game(snapshot: snapshot)
            
            // add this to the table data
            self.tableData.append(gameData)
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // attatch handle
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            // check if user is logged in
            if (Auth.auth().currentUser == nil) {
                // send to login screen
                let storyboard = UIStoryboard(name: "Main", bundle: self.nibBundle)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
                self.present(loginViewController, animated: false, completion: nil)
            }
        })
        
        // check for match changes
        dbRef.child("matches").observe(.value) { (snapshot) in

            if snapshot.hasChildren() {
        
                // set data attr and reload
                self.data = .deafult
            }
            else {
                // set data attr and reload
                self.data = .nogames
            }
            
            self.tableView.reloadData()
        }
        
        childChangedListener = dbRef.child("matches").observe(.childChanged) { (snapshot) in
            
            // save value of snapshot
            let snapValue = game(snapshot: snapshot)
            
            // find where the value of the update is in the table data
            if let oldMatchDataIndex = self.tableData.index(where: { $0.matchCode ==  snapValue.matchCode}) {
                // update new value
                self.tableData[oldMatchDataIndex] = snapValue
                
                // reload table data
                self.tableView.reloadData()
            }

        } 
        
        // listen for when they are deleted
        dbRef.child("matches").observe(.childRemoved) { (snapshot) in
            
            // check that there is data in the table
            if (self.tableData.count - 1) >= 0 {
            
                // loop through table entries
                for entry in 0...self.tableData.count - 1 {
                    
                    // check if entry exists
                    if (self.tableData[entry].matchCode) == (game(snapshot: snapshot).matchCode) {
                        
                        // remove it from the table
                        self.tableData.remove(at: entry)
                        self.tableView.deleteSections([entry], with: UITableViewRowAnimation.left)
                    }
                }
            }
        }
        
        dbRef.child("matches").child(currentMatchCode).removeAllObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // detach handle
        Auth.auth().removeStateDidChangeListener(handle)
        dbRef.removeAllObservers()
        dbRef.removeObserver(withHandle: childChangedListener)
    }
    
    // fired when delete is triggered
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        // check if there are matches
        if data == .deafult {
            
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { (action, cellPath) in
                
                // remove from firebase
                self.dbRef.child("matches").child(self.tableData[indexPath.section].matchCode).removeValue()
                
                // remove cell path from array and table
                self.tableData.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: UITableViewRowAnimation.left)
                
            })
            
            return [deleteAction]
        }
        else {
            return nil
        }
    }
    
    // fired when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // check if there are matches and this isn't a placeholder
        if data == .deafult {
            
            // get cell we want
            let tappedCell = tableView.cellForRow(at: indexPath) as! matchTableViewCell
            
            // empty segue data
            segueData.removeAll()
            
            // append all fo the data that we need
            segueData.append(tappedCell.matchCode)
            segueData.append(tappedCell.completed)
            segueData.append(tappedCell.playerAName)
            segueData.append(tappedCell.playerASchool)
            segueData.append(tappedCell.playerBName)
            segueData.append(tappedCell.playerBSchool)
            segueData.append(tappedCell.courtNumber)
            
            // instantiate matchdetail view controler
            let storyboardRef = UIStoryboard(name: "Main", bundle: nil)
            // find nav
            let destViewContoller = storyboardRef.instantiateViewController(withIdentifier: "editNav") as! UINavigationController
            // find edit view controoller
            let detailViewController = destViewContoller.visibleViewController as! matchDetailViewController
            
            // set values that we need
            detailViewController.matchCode = segueData[0] as! String
            detailViewController.completed = segueData[1] as! Bool
            detailViewController.playerAName = segueData[2] as! String
            detailViewController.playerASchool = segueData[3] as! String
            detailViewController.playerBName = segueData[4] as! String
            detailViewController.playerBSchool = segueData[5] as! String
            detailViewController.courtNumber = segueData[6] as! String
            detailViewController.index = indexPath.section
            
            // set current match code for later
            currentMatchCode = tappedCell.matchCode
            
            // attach a data handler for this game that fires when this cell is changed
            tappedCellRef = dbRef.child("matches").child(tappedCell.matchCode).observe(.value, with: { (snapshot) in
                
                // get this snap as a game object
                let updatedData = game(snapshot: snapshot)
                
                // update tabledata
                self.tableData[indexPath.section] = updatedData
                
                // update the table
                self.tableView.reloadData()
                
            })
            
            // present nav controller
            self.present(destViewContoller, animated: true, completion: nil)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // check if we are going to the detail controller
//        if segue.identifier == "detailController" {
//
//            // instantiate matchdetail view controler
//            let destViewContoller = segue.destination as! UINavigationController
//            let detailViewController = destViewContoller.visibleViewController as! matchDetailViewController
//
//            // set values that we need
//            detailViewController.matchCode = segueData[0] as! String
//            detailViewController.completed = segueData[1] as! Bool
//            detailViewController.playerAName = segueData[2] as! String
//            detailViewController.playerASchool = segueData[3] as! String
//            detailViewController.playerBName = segueData[4] as! String
//            detailViewController.playerBSchool = segueData[5] as! String
//            detailViewController.courtNumber = segueData[6] as! String
//
//        }
//    }
}


