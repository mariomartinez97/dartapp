//
//  SettingsViewController.swift
//  FriendlyChatSwift
//
//  Created by Mario Miguel on 10/17/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var mainnameText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var changeNametext: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainnameText.text = FIRAuth.auth()?.currentUser?.displayName
        emailText.text = FIRAuth.auth()?.currentUser?.email
        
        mainnameText.isHidden = false
        changeNametext.isHidden = true
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }

    @IBAction func pressBack(_ sender: AnyObject) {
        performSegue(withIdentifier: "backChat", sender: nil)
    }
    
    @IBAction func pressNameChange(_ sender: AnyObject) {
        mainnameText.isHidden = true
        changeNametext.isHidden = false
        saveButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    @IBAction func pressCancel(_ sender: AnyObject) {
        mainnameText.isHidden = false
        changeNametext.isHidden = true
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @IBAction func pressSave(_ sender: AnyObject) {
        
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let changeRequest = user.profileChangeRequest()
            
            changeRequest.displayName = changeNametext.text!
            changeRequest.commitChanges() { error in
                if let error = error {
                    print(error)
                }
            else{
                print(FIRAuth.auth()?.currentUser?.profileChangeRequest().displayName)
                self.mainnameText.text = FIRAuth.auth()?.currentUser?.displayName
                self.mainnameText.isHidden = false
                self.changeNametext.isHidden = true
                self.saveButton.isHidden = true
                self.cancelButton.isHidden = true

                }
            }
        }
    }
}
