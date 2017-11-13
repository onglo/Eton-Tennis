//
//  loginViewController.swift
//  Eton Tennis
//
//  Created by Edouard Long on 22/10/2017.
//  Copyright © 2017 Edouard Long. All rights reserved.
//

import UIKit
import FirebaseAuth

class loginViewController: UIViewController {

    // attach username and password field
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    // init a did change state handler
    var authHandle:AuthStateDidChangeListenerHandle!
    
    // func executed when button is pressed
    @IBAction func buttonPressed(_ sender: Any) {
        
        // check if any of the fields are empty
        if (usernameInput.text == "" || passwordInput.text == "") {
            // tell the user the inputs are empty
            let emptyAlert = UIAlertController(title: "Please fill in the fields and try again", message: "One or more of the entry fields are empty", preferredStyle: UIAlertControllerStyle.alert)
            emptyAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(emptyAlert, animated: true)
        }
        else {
            // attempt to login the user
            Auth.auth().signIn(withEmail: usernameInput.text!, password: passwordInput.text!) { (user, error) in
                
                // check if there was an error
                if (error != nil) {

                    // tell the user there was an error
                    let loginError = UIAlertController(title: "Error loging in", message: "Please double check your username and password", preferredStyle: UIAlertControllerStyle.alert)
                    loginError.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(loginError, animated: true)
                    
                }
                
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // set border of text fields to white
        passwordInput.layer.borderWidth = 1
        usernameInput.layer.borderWidth = 1
        passwordInput.layer.borderColor = UIColor.white.cgColor
        usernameInput.layer.borderColor = UIColor.white.cgColor

        // init username icon image view and password
        let usernameIconImageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 40, height: 20))
        let passwordIconImageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 40, height: 20))
        
        usernameIconImageView.contentMode = UIViewContentMode.scaleAspectFit
        passwordIconImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        // find icon
        let usernameIcon = UIImage(named: "userIcon")
        let passwordIcon = UIImage(named: "passwordIcon")
        
        // set image view image to the username icon
        usernameIconImageView.image = usernameIcon
        passwordIconImageView.image = passwordIcon
        
        // set left view of input to be this icon
        usernameInput.leftView = usernameIconImageView
        usernameInput.leftViewMode = UITextFieldViewMode.always
        passwordInput.leftView = passwordIconImageView
        passwordInput.leftViewMode = UITextFieldViewMode.always

        // attach handle that will check if the user is authenticated
        authHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            // check if a user is logged in
            if (Auth.auth().currentUser != nil) {
                // user logged in
                // segue to main scene
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            }
    
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove handler
        Auth.auth().removeStateDidChangeListener(authHandle)
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
