//
//  RegisterViewController.swift
//  Swift_FireMapsCore_JGC
//
//  Created by Javier Gandia on 27/11/2019.
//  Copyright © 2019 Javier Gandia. All rights reserved.
//


import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    let db = Firestore.firestore()
    @IBOutlet weak var gmailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func makeRegister(){
        let registerDocument = db.collection("users").document()
        registerDocument.setData(["gmail":"\(String(describing: gmailTxt.text))","name":"\(String(describing: nameTxt.text))","password":"\(String(describing: passwordTxt.text))"])
    }
}
