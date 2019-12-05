//
//  ProfileViewController.swift
//  Swift_FireMapsCore_JGC
//
//  Created by Javier Gandia on 02/12/2019.
//  Copyright © 2019 Javier Gandia. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
import GoogleSignIn
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gmailLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        gmailLabel.text = ""
        getOfFirebase()
        getOfCoreData()
    }
    
    func getOfFirebase(){
        //take email of the current user to find email and name from firebase
        var actualGmail = Auth.auth().currentUser?.email
        if actualGmail == nil{
            actualGmail = "powershoot19@gmail.com"
        }
        db.collection("users").whereField("gmail", isEqualTo: actualGmail! ).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let valueName = document.data().index(forKey: "name")
                    let dicname = document.data()[valueName!].value as! String
                    
                    let valueGmail = document.data().index(forKey: "gmail")
                    let dicgmail =  document.data()[valueGmail!].value as! String
                    
                    self.gmailLabel.text = dicgmail
                    self.nameLabel.text  = dicname
                }
            }
        }
    }
    
    func getOfCoreData(){
        guard let users = try! PersistenceService.context.fetch(Users.fetchRequest()) as? [Users]
            else { return }
        users.forEach({
            idLabel.text = $0.id
        })
    }
    
    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            PersistenceService.deleteAllCodesRecords()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = loginViewController
        appDelegate?.window??.makeToast("log Out Succesfull!!")
        
    }
    
}
