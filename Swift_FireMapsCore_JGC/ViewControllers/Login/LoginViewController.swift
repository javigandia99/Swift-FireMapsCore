//
//  ViewController.swift
//  Swift_FireMapsCore_JGC
//
//  Created by Javier Gandia on 27/11/2019.
//  Copyright © 2019 Javier Gandia. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    // let db = Firestore.firestore()
    
    @IBOutlet weak var gmailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if error != nil {
            
            self.showError(error: error!)
            
            return
        }
        print("Succesfully logged into Google", user!)
        guard user.authentication.idToken != nil else { return }
        guard user.authentication.accessToken != nil else { return }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential, completion: {(user,error) in
            if error != nil {
                // Couldn't sign in
                self.showError(error: error!)
            }
            else {
                //if everything okey go to MapView
                self.goToMaps()
            }})
        goToMaps()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        // Create cleaned versions of the text field
        let gmail = gmailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: gmail, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.showError(error: error!)
            }
            else {
                //if everything okey go to MapView
                self.goToMaps()
            }
        }
    }
    
    func showError(error:Error){
        self.errorLabel.text = error.localizedDescription
        self.errorLabel.alpha = 1
    }
    
    func goToMaps(){
        
        let mapsView = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mapsViewController) as? MapsViewController
        
        self.view.window?.rootViewController = mapsView
        self.view.window?.makeKeyAndVisible()
    }
    
}

