//
//  SignUp.swift
//  FriendlyChatSwift
//
//  Created by Mario Miguel on 10/17/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var errorText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pressCancel(_ sender: AnyObject) {
        performSegue(withIdentifier: "cancel", sender: nil)
    }
    
    @IBAction func pressSign(_ sender: AnyObject) {
        guard let email = emailText.text, let password = passwordText.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                self.errorText.text = error.localizedDescription
                //print(error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
        }
        emailText.text = ""
        passwordText.text = ""
    }
    
    func setDisplayName(_ user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        
        changeRequest.displayName = nameText.text!
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    func signedIn(_ user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
    }
}
