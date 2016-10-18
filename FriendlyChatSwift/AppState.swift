//
//  ChannelsViewController.swift
//  FriendlyChatSwift
//
//  Created by Mario Miguel on 10/12/16.
//  Copyright © 2016 Google Inc. All rights reserved.
//

import Foundation

class AppState: NSObject {

  static let sharedInstance = AppState()

  var signedIn = false
  var displayName: String?
  var photoURL: URL?
}
