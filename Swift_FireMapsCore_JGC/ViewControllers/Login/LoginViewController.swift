//
//  ViewController.swift
//  Swift_FireMapsCore_JGC
//
//  Created by Javier Gandia on 27/11/2019.
//  Copyright © 2019 Javier Gandia. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // let db = Firestore.firestore()
    
    @IBOutlet weak var gmailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        // Create cleaned versions of the text field
        let gmail = gmailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: gmail, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                //if all okey go to MapView
                self.goToMaps()
            }
        }
    }
    
    func goToMaps(){
        
        let mapsView = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mapsViewController) as? MapsViewController
        
        self.view.window?.rootViewController = mapsView
        self.view.window?.makeKeyAndVisible()
    }
    
}

