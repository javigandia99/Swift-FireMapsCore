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
import CoreData

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var gmailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let persistanceServices = PersistenceService.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //AutoLogin with Firebase()
        //if Auth.auth().currentUser != nil {
        // goToMaps()
        //}
        //auto login with coreData
        autoLogin()
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
            }else {
                //save id in coreData
                self.saveCoreData()
                //if everything okey go to MapView
                self.goToMaps()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            // Couldn't sign in
            self.showError(error: error!)
        }else{
            // This func is to save data but he crash
            //self.saveCoreData()
            self.goToMaps()
        }
    }
    
    func showError(error:Error){
        self.errorLabel.text = error.localizedDescription
        self.errorLabel.alpha = 1
    }
    
    func goToMaps(){
        let tabBarView = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarViewController) as? UITabBarController
        
        self.view.window?.rootViewController = tabBarView
        self.view.window?.makeKeyAndVisible()
    }
    
    func saveCoreData(){
        let idEntity = NSEntityDescription.entity(forEntityName: "Users", in: persistanceServices.context)!
        let user = NSManagedObject(entity: idEntity, insertInto: persistanceServices.context)
        let id = Auth.auth().currentUser?.uid
        user.setValue(id!, forKey: "id")
        
        _ =  self.persistanceServices.saveContext()
    }
    
    func autoLogin(){
        //CoreData, autologin only with email
        // GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        var id: String = ""
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do{
            
            let result = try persistanceServices.context.fetch(fetchRequest)
            
            for user in result as! [NSManagedObject] {
                id = user.value(forKey: "id") as! String
            }
            if (!id.isEmpty){
                self.goToMaps()
            }
        }catch{
            print("error autologin")
        }
    }
}
