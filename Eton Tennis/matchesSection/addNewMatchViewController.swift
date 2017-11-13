//
//  addNewMatchViewController.swift
//  Eton Tennis
//
//  Created by Edouard Long on 23/10/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class addNewMatchViewController: UIViewController {

    // link all the inputs
    @IBOutlet weak var courtNumberInput: UITextField!
    @IBOutlet weak var playerANameInput: UITextField!
    @IBOutlet weak var playerASchoolInput: UITextField!
    @IBOutlet weak var playerBNameInput: UITextField!
    @IBOutlet weak var playerBSchoolInput: UITextField!
    @IBOutlet weak var numberOfSets: UISegmentedControl!
    
    // init db ref
    var dbRef:DatabaseReference!
    
    // array of inputs
    @IBOutlet var inputs: [UITextField]!
    
    // init auth handle
    var handle:AuthStateDidChangeListenerHandle!
    
    // init match code
    var tempCode:String!
    
    // action executed when close button is pressed
    @IBAction func closePressed(_ sender: Any) {
        
        // close popup
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // action executed when add match is pressed
    @IBAction func addPressed(_ sender: Any) {
        
        // check if any of the fields are empty
        var empty = false
        for input in inputs {
            // check if it is empty
            if input.text == "" {
                empty = true
                break
            }
        }
        
        if empty == true {
            
            // tell the user fields are empty 
            let emptyAlert = UIAlertController(title: "Error", message: "One or more of the entry fields are empty", preferredStyle: UIAlertControllerStyle.alert)
            emptyAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(emptyAlert, animated: true)
            
            return
        }
    
        // check how many sets the user wants
        var noOfSets:Int!
        if numberOfSets.selectedSegmentIndex == 0 {
            // 1 set
            noOfSets = 1
        }
        else if numberOfSets.selectedSegmentIndex == 1 {
            // 3 sets
            noOfSets = 3
        }
        else {
            // 5 sets
            noOfSets = 5
        }
        
        // init first game
        let gameScore = ["0-0"]

            
        // generate match code
        tempCode = randomString(length: 5)
        
        // create instance of game
        let gameInfo = game(playerAParameter: playerANameInput.text!, playerASchoolParameter: playerASchoolInput.text!, playerBParameter: playerBNameInput.text!, playerBSchoolParameter: playerBSchoolInput.text!, scoreParameter: gameScore, completedParameter: false, matchCodeParameter: tempCode, numberOfSetsParameter: noOfSets, courtNumberParameter: courtNumberInput.text!)

        
        // attempt to write info
        dbRef.child("matches").child(tempCode).setValue(gameInfo.toAnyObject())
        
        // segue to game created
        self.performSegue(withIdentifier: "matchConfirmation", sender: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set data ref
        dbRef = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // loop through all the inputs
        for input in inputs {
            
            // give them a white border
            input.layer.borderWidth = 1
            input.layer.borderColor = UIColor.white.cgColor
            
            // clear text
            input.text = ""
            
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // detach handle
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // check if we are going to confirmation
        if segue.identifier == "matchConfirmation" {
            
            // get destination view controller
            let confirmationViewController = segue.destination as! matchCreationCompletedViewController
            
            // set all of the attributes we need
            confirmationViewController.courtLabelText = "Court \(courtNumberInput.text!)"
            confirmationViewController.playerALabelText = "\(playerANameInput.text!) (\(playerASchoolInput.text!))"
            confirmationViewController.playerBLabelText = "\(playerBNameInput.text!) (\(playerBSchoolInput.text!))"
            confirmationViewController.matchCodeLabelText = "Match Code: \(tempCode!)"
            
        }
    }
    
    // func to generate random match string
    func randomString(length: Int) -> String {
        
        // choose set of leters we will use
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        // set length of string
        let len = UInt32(letters.length)
        
        // init string
        var randomString = ""
        
        
        // loop for each random letter we need
        for _ in 0 ..< length {
            
            // generate a random number
            let rand = arc4random_uniform(len)
            
            // get this as representation of a letter
            var nextChar = letters.character(at: Int(rand))
            
            // add this to the random string
            
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

}
