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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gmailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //valuesOfFirebase()
        
    }
    
    func valuesOfFirebase(){
        
    }
    
    @IBAction func didTapLogOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = loginViewController
            appDelegate?.window??.makeToast("log Out Succesfull!!")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
