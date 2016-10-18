//
//  UserViewController.swift
//  FriendlyChatSwift
//
//  Created by Mario Miguel on 10/10/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

import Photos
import UIKit

import Firebase

@objc(FCViewController)
class FCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  // Instance variables
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var sendButton: UIButton!

  var ref: FIRDatabaseReference!
  var messages: [FIRDataSnapshot]! = []
  var msglength: NSNumber = 150
  fileprivate var _refHandle: FIRDatabaseHandle!

  var storageRef: FIRStorageReference!
  var remoteConfig: FIRRemoteConfig!

    var abc = 0
    
  @IBOutlet weak var clientTable: UITableView!
    
    var channel1 = "1"
    var channel2 = "2"
    
  override func viewDidLoad() {
    super.viewDidLoad()

    self.clientTable.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")

    configureDatabase()
    configureStorage()
    configureRemoteConfig()
    fetchConfig()
  }

    deinit {
        self.ref.child("messages").removeObserver(withHandle: _refHandle)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        //_refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            
            _refHandle = self.ref.child("messages").queryOrdered(byChild: "channel").queryEqual(toValue: "1").observe(.childAdded, with: { [weak self] (snapshot) -> Void in

            //let temp = snapshot.childSnapshot(forPath: ("channel"))
            //print (temp)
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
            })
    }
    
    func configureStorage() {
        
        storageRef = FIRStorage.storage().reference(forURL: "gs://swift3dartapp.appspot.com/")
    }

  func configureRemoteConfig() {
    remoteConfig = FIRRemoteConfig.remoteConfig()
    // Create Remote Config Setting to enable developer mode.
    // Fetching configs from the server is normally limited to 5 requests per hour.
    // Enabling developer mode allows many more requests to be made per hour, so developers
    // can test different config values during development.
    let remoteConfigSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
    remoteConfig.configSettings = remoteConfigSettings!
  }

  func fetchConfig() {
    var expirationDuration: Double = 3600
    // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
    // the server.
    if (self.remoteConfig.configSettings.isDeveloperModeEnabled) {
        expirationDuration = 0
    }
    
    // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
    // fetched and cached config would be considered expired because it would have been fetched
    // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
    // throttling is in progress. The default expiration duration is 43200 (12 hours).
    remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
        if (status == .success) {
            print("Config fetched!")
            self.remoteConfig.activateFetched()
            let friendlyMsgLength = self.remoteConfig["friendly_msg_length"]
            if (friendlyMsgLength.source != .static) {
                self.msglength = friendlyMsgLength.numberValue!
                print("Friendly msg length config: \(self.msglength)")
            }
        } else {
            print("Config not fetched")
            print("Error \(error)")
        }
    }
    
  }

  @IBAction func didSendMessage(_ sender: UIButton) {
    textFieldShouldReturn(textField)
    textField.text = ""
  }


  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }

    let newLength = text.characters.count + string.characters.count - range.length
    return newLength <= self.msglength.intValue // Bool
  }

  // UITableViewDataSource protocol methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = self.clientTable .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, String>
        
        //Doesnt work to filter
        //let channel = message[Constants.MessageFields.channel] as String!
        
        let name = message[Constants.MessageFields.name] as String!
        let text = message[Constants.MessageFields.text] as String!
            
            cell.textLabel?.text = name! + ": " + text!
            cell.backgroundColor = UIColor.white
            cell.tintColor = UIColor.white
            cell.imageView?.image = UIImage(named: "ic_account_circle")
            if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL), let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage(data: data)
                

        }
        return cell
    }

  // UITextViewDelegate protocol methods
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return true }
    let data = [Constants.MessageFields.text: text]
    sendMessage(withData: data)
    textField.text = ""
    return true
  }

    func sendMessage(withData data: [String: String]) {
        var mdata = data
        mdata[Constants.MessageFields.name] = AppState.sharedInstance.displayName
        mdata[Constants.MessageFields.channel] = channel1
        if let photoURL = AppState.sharedInstance.photoURL {
            mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    
  @IBAction func signOut(_ sender: UIButton) {
    let firebaseAuth = FIRAuth.auth()
    do {
        try firebaseAuth?.signOut()
        performSegue(withIdentifier: "FPToSignIn", sender: nil)
    } catch let signOutError as NSError {
        print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    

}
