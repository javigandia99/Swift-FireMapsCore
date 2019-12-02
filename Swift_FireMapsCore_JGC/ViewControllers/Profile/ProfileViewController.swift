//
//  ProfileViewController.swift
//  Swift_FireMapsCore_JGC
//
//  Created by Javier Gandia on 02/12/2019.
//  Copyright © 2019 Javier Gandia. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //valuesOfFirebase()
        
    }
    
    func valuesOfFirebase(){
       let db = Firestore.firestore().collection("users").document()
        db.getDocument{(document,error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
            
            
        }
    }
    
    @IBAction func didTapLogOut(_ sender: UIButton) {
        //GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
