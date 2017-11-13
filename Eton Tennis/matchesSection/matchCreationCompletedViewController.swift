//
//  matchCreationCompletedViewController.swift
//  Eton Tennis
//
//  Created by Edouard Long on 27/10/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import UIKit
import FirebaseAuth

class matchCreationCompletedViewController: UIViewController {
    
    // link labels
    @IBOutlet weak var courtLabel: UILabel!
    @IBOutlet weak var playerALabel: UILabel!
    @IBOutlet weak var playerBLabel: UILabel!
    @IBOutlet weak var matchCodeLabel: UILabel!
    
    // vars we need
    var courtLabelText:String!
    var playerALabelText:String!
    var playerBLabelText:String!
    var matchCodeLabelText:String!
    
    // init handle
    var handle:AuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    // excecuted when done button is pressed
    @IBAction func donePressed(_ sender: Any) {
        
        // close popup
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set labels
        courtLabel.text = courtLabelText
        playerALabel.text = playerALabelText
        playerBLabel.text = playerBLabelText
        matchCodeLabel.text = matchCodeLabelText
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
