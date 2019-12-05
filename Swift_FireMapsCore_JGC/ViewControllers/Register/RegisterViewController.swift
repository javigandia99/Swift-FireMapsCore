//
//  RegisterViewController.swift
//  Swift_FireMapsCore_JGC
//
//  Created by Javier Gandia on 27/11/2019.
//  Copyright © 2019 Javier Gandia. All rights reserved.
//


import UIKit
import Firebase
import CoreData

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var gmailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let persistanceServices = PersistenceService.self
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set error label invisible
        errorLabel.alpha = 0
        
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        // Check that all fields are filled in
        if gmailTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        func isPasswordValid(_ password : String) -> Bool {
            //Regex for check password: Minimum 8 characters at least 1 Alphabet and 1 Number
            let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
            return passwordTest.evaluate(with: password)
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters at least 1 Alphabet and 1 Number."
        }
        
        return nil
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message
            self.errorLabel.text = error
            self.errorLabel.alpha = 1
        }
        else {
            // Create cleaned versions of the data
            let gmail = gmailTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = nameTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: gmail, password: password) { (result, error) in
                // Check for errors
                if error != nil {
                    // There was an error creating the user
                    self.showError(error: error!)
                }
                else {
                    // User was created successfully, now store the gmail and name
                    self.db.collection("users").document(result!.user.uid).setData(["gmail" : gmail, "name":name]){ (error) in
                        if error != nil {
                            self.showError(error: error!)
                        }
                    }
                    //save id in coreData to make auto login 
                    self.saveCoreData()
                    // Transition to the Maps screen
                    self.goToMaps()
                }
            }
        }
    }
    
    func saveCoreData(){
        let idEntity = NSEntityDescription.entity(forEntityName: "Users", in: persistanceServices.context)!
        let user = NSManagedObject(entity: idEntity, insertInto: persistanceServices.context)
        let id = Auth.auth().currentUser?.uid
        user.setValue(id!, forKey: "id")
        
        _ =  self.persistanceServices.saveContext()
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
}
