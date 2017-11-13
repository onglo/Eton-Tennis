//
//  matchDetailViewController.swift
//  Eton Tennis
//
//  Created by Edouard Long on 29/10/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class matchDetailViewController: UIViewController {

    // link court and player inputs
    @IBOutlet weak var courtNumberInput: UITextField!
    @IBOutlet weak var playerANameInput: UITextField!
    @IBOutlet weak var playerASchoolInput: UITextField!
    @IBOutlet weak var playerBNameInput: UITextField!
    @IBOutlet weak var playerBSchoolInput: UITextField!
    
    // init did change state auth handle
    var handle:AuthStateDidChangeListenerHandle!
    
    // init db ref
    var dbRef:DatabaseReference!
    
    // link progress slider
    @IBOutlet weak var completedSlider: UISegmentedControl!
    
    // init vars which will control values
    var courtNumber:String!
    var playerAName:String!
    var playerASchool:String!
    var playerBName:String!
    var playerBSchool:String!
    var completed:Bool!
    var matchCode:String!
    var index:Int!
    
    // init matches vc
    var matchesVC:matchesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // find the tableview inside the matches view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        matchesVC = storyboard.instantiateViewController(withIdentifier: "matchesVC") as! matchesViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set values of inputs and placeholder
        playerANameInput.text = playerAName
        playerASchoolInput.text = playerASchool
        playerBNameInput.text = playerBName
        playerBSchoolInput.text = playerBSchool
        courtNumberInput.text = courtNumber
        
        // figure out segemented control value
        if completed {
            completedSlider.selectedSegmentIndex = 1
        }
        else {
            completedSlider.selectedSegmentIndex = 0
        }
        
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
        
        // set db ref
        dbRef = Database.database().reference()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // detach handle
        Auth.auth().removeStateDidChangeListener(handle)
        dbRef.removeAllObservers()
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        
        // check which input has changed by comparing tags 
        let tag = (sender as AnyObject).tag
        
        if tag == 0 {
            // court number
            
            // get input value
            let inputValue = (sender as! UITextField).text
            
            // update field 
            dbRef.child("matches").child(matchCode).child("courtNumber").setValue(inputValue)

        }
        else if tag == 1 {
            // player a name
            // get input value
            let inputValue = (sender as! UITextField).text
            
            // update field
            dbRef.child("matches").child(matchCode).child("playerA").setValue(inputValue)
        }
        else if tag == 2{
            // player a school
            // get input value
            let inputValue = (sender as! UITextField).text
            
            // update field
            dbRef.child("matches").child(matchCode).child("playerASchool").setValue(inputValue)

        }
        else if tag == 3 {
            // player b name
            // get input value
            let inputValue = (sender as! UITextField).text
            
            // update field
            dbRef.child("matches").child(matchCode).child("playerB").setValue(inputValue)

        }
        else if tag == 4 {
            // player b school
            // get input value
            let inputValue = (sender as! UITextField).text
            
            // update field
            dbRef.child("matches").child(matchCode).child("playerBSchool").setValue(inputValue)

        }
        else {
            // progress chooser
            // get input value
            let inputValue = (sender as! UISegmentedControl).selectedSegmentIndex
            
            // init state vaalue
            var state = false
            
            // check if true or false
            if inputValue == 1 {
                state = true
            } // if not one already false
            
            // update field
            dbRef.child("matches").child(matchCode).child("completed").setValue(state)
            
        }
    }
    
    
    // executed when the close button is pressed
    @IBAction func closePressed(_ sender: Any) {
        
        // go back to main view controller
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
