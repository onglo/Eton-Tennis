//
//  statsTableViewController.swift
//  
//
//  Created by Edouard Long on 21/11/2017.
//

import UIKit
import FirebaseDatabase

class statsTableViewController: UITableViewController {
    
    // var that keeps track of data state
    var dataState = "loading"
    
    // create db value
    var dbRef:DatabaseReference!
    
    // large data array
    var DataArray:[GameScore]!
    
    // connect table view

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set db ref
        dbRef = Database.database().reference()
        
        // set height of cells
        self.tableView.rowHeight = 80.0
        
        // single listener for value of stats
        dbRef.child("players").observe(.childAdded) { (snapshot) in
            
            // append data value to data array
            self.DataArray.append(GameScore(snapshot: snapshot))
            
        }
        
        // check for match changes
        dbRef.child("matches").observe(.value) { (snapshot) in
            
            if snapshot.hasChildren() {
                
                
            }
            else {
                
            }
            
            print(self.DataArray)
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // init number of sections
        var numberOfSections:Int!
        
        // check if the table is loading data
        if (dataState == "loading"){
            
            // only need one cell
            numberOfSections = 1
            
        }
        
        return numberOfSections;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell prototype
        let matchesCell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! leaderBoardTableViewCell
        
        // check if we are loading data
        if (dataState == "loading") {
            
            // set label to loading
            matchesCell.mainTextLabel.text = "Loading..."
            
            return matchesCell
        }
        
        return matchesCell

    }

    // set height of section
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    // make section split transparent
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // create a new view
        let transparentView = UIView()
        
        // make it transparent
        transparentView.backgroundColor = UIColor.clear
        
        return transparentView
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
